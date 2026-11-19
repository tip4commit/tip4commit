# frozen_string_literal: true

require 'spec_helper'

describe Tip, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :sendmany }
    it { is_expected.to belong_to :project }
  end

  describe 'reopened tips' do
    include ActiveSupport::Testing::TimeHelpers

    let(:project) { create(:project) }
    let(:user) { create(:user) }

    before { create(:deposit, project:, amount: 10_000, confirmations: 3) }

    def make_tip(attrs = {})
      create(:tip, { project:, user: }.merge(attrs))
    end

    # Direct writes so tests can set clock columns without running model callbacks.
    def force_columns(tip, **attrs)
      tip.update_columns(**attrs) # rubocop:disable Rails/SkipsModelValidations
    end

    # Brings the cached balance up to date so a later change is visible as a stale cache.
    def refresh_cache
      project.update_columns(available_amount_cache: project.available_amount) # rubocop:disable Rails/SkipsModelValidations
    end

    # Project#update_cache uses update, which a project failing validation silently refuses.
    def make_project_invalid
      project.update_columns(host: 'nowhere') # rubocop:disable Rails/SkipsModelValidations
      expect(project.reload).not_to be_valid
    end

    # acts_as_paranoid hides the soft-deleted project, so the reloaded tip's project is nil.
    def tip_on_deleted_project(amount:, refunded_at: nil)
      tip = make_tip(amount:)
      force_columns(tip, refunded_at:) if refunded_at
      project.destroy
      tip = described_class.find(tip.id)
      expect(tip.project).to be_nil
      tip
    end

    describe '.auto_decide_older_tips' do
      it 'leaves an old undecided tip alone when reopened 1 day ago' do
        tip = make_tip(amount: nil)
        force_columns(tip, created_at: 2.months.ago, reopened_at: 1.day.ago)

        described_class.auto_decide_older_tips

        expect(tip.reload).to be_undecided
      end

      it 'decides an old undecided tip when reopened 32 days ago' do
        tip = make_tip(amount: nil)
        force_columns(tip, created_at: 2.months.ago, reopened_at: 32.days.ago)

        described_class.auto_decide_older_tips

        expect(tip.reload).to be_decided
      end

      it 'still decides old undecided tips with no reopened_at' do
        tip = make_tip(amount: nil)
        force_columns(tip, created_at: 2.months.ago)

        described_class.auto_decide_older_tips

        expect(tip.reload).to be_decided
      end
    end

    describe '.refund_unclaimed' do
      it 'does not refund a decided tip reopened 1 day ago' do
        tip = make_tip(amount: 5)
        force_columns(tip, decided_at: 2.months.ago, reopened_at: 1.day.ago)

        described_class.refund_unclaimed

        expect(tip.reload).not_to be_refunded
      end

      it 'refunds a decided tip reopened 32 days ago' do
        tip = make_tip(amount: 5)
        force_columns(tip, decided_at: 2.months.ago, reopened_at: 32.days.ago)

        described_class.refund_unclaimed

        expect(tip.reload).to be_refunded
      end

      it 'still refunds old decided tips with no reopened_at' do
        tip = make_tip(amount: 5)
        force_columns(tip, decided_at: 2.months.ago)

        described_class.refund_unclaimed

        expect(tip.reload).to be_refunded
      end
    end

    describe 'refund month counted from the later of decision and reopening' do
      it 'does not refund a reopened tip in the same pass that auto-decides it' do
        tip = make_tip(amount: nil)
        force_columns(tip, created_at: 3.months.ago, reopened_at: 32.days.ago)

        described_class.auto_decide_older_tips
        described_class.refund_unclaimed

        expect(tip.reload).to be_decided
        expect(tip).not_to be_refunded
      end

      it 'counts from decided_at when it is later than reopened_at' do
        tip = make_tip(amount: 5)
        force_columns(tip, decided_at: 10.days.ago, reopened_at: 40.days.ago)

        described_class.refund_unclaimed
        expect(tip.reload).not_to be_refunded

        force_columns(tip, decided_at: 32.days.ago)
        described_class.refund_unclaimed
        expect(tip.reload).to be_refunded
      end

      it 'counts from reopened_at for an un-refunded tip' do
        tip = make_tip(amount: 5)
        force_columns(tip, decided_at: 3.months.ago, reopened_at: 1.day.ago)

        described_class.refund_unclaimed
        expect(tip.reload).not_to be_refunded

        force_columns(tip, reopened_at: 32.days.ago)
        described_class.refund_unclaimed
        expect(tip.reload).to be_refunded
      end
    end

    describe '#reopen!' do
      it 'makes a decided tip undecided and restarts the clock' do
        tip = make_tip(amount: 5)
        available_before = project.available_amount

        freeze_time do
          tip.reopen!
          expect(tip.reload.reopened_at).to eq(Time.zone.now)
        end

        expect(tip).to be_undecided
        expect(tip.decided_at).to be_nil
        expect(tip).to be_non_refunded
        expect(project.available_amount).to eq(available_before + 5)
      end

      it 'reopens a refunded tip and clears refunded_at' do
        tip = make_tip(amount: 5)
        force_columns(tip, refunded_at: 1.day.ago)

        tip.reopen!

        expect(tip.reload).to be_undecided
        expect(tip).to be_non_refunded
        expect(tip.reopened_at).not_to be_nil
      end

      it 'refreshes the project balance cache' do
        tip = make_tip(amount: 5)
        refresh_cache

        tip.reopen!

        expect(project.reload.available_amount_cache).to eq(project.available_amount)
      end

      it 'leaves the project balance unchanged when reopening a refunded tip' do
        tip = make_tip(amount: 5)
        force_columns(tip, refunded_at: 1.day.ago)
        available_before = project.available_amount

        tip.reopen!

        expect(project.available_amount).to eq(available_before)
      end

      it 'refreshes the cache even when the project fails validation' do
        tip = make_tip(amount: 5)
        refresh_cache
        make_project_invalid

        tip.reopen!

        expect(project.reload.available_amount_cache).to eq(project.available_amount)
      end

      it 'reopens a tip whose project was soft-deleted' do
        tip = tip_on_deleted_project(amount: 5)

        tip.reopen!

        expect(tip.reload).to be_undecided
        expect(tip.reopened_at).not_to be_nil
      end

      it 'raises AlreadyPaid for a paid tip and changes nothing' do
        tip = make_tip(amount: 5)
        force_columns(tip, sendmany_id: create(:sendmany).id)

        expect { tip.reopen! }.to raise_error(Tip::AlreadyPaid)
        expect(tip.reload.amount).to eq(5)
        expect(tip.reopened_at).to be_nil
      end
    end

    describe '#unrefund!' do
      it 'clears refunded_at, keeps amount and decided_at, and sets reopened_at' do
        tip = make_tip(amount: 5)
        decided_at = 2.months.ago.change(usec: 0)
        force_columns(tip, decided_at:, refunded_at: 1.day.ago)

        freeze_time do
          tip.unrefund!
          expect(tip.reload.reopened_at).to eq(Time.zone.now)
        end

        expect(tip).to be_non_refunded
        expect(tip.amount).to eq(5)
        expect(tip.decided_at).to eq(decided_at)
      end

      it 'refreshes the project balance cache' do
        tip = make_tip(amount: 5)
        force_columns(tip, refunded_at: 1.day.ago)
        refresh_cache

        tip.unrefund!

        expect(project.reload.available_amount_cache).to eq(project.available_amount)
      end

      it 'raises ArgumentError for a tip that is not refunded' do
        tip = make_tip(amount: 5)

        expect { tip.unrefund! }.to raise_error(ArgumentError)
      end

      it 'raises AlreadyPaid for a paid tip' do
        tip = make_tip(amount: 5)
        force_columns(tip, refunded_at: 1.day.ago, sendmany_id: create(:sendmany).id)

        expect { tip.unrefund! }.to raise_error(Tip::AlreadyPaid)
        expect(tip.reload).to be_refunded
      end

      it 'refreshes the cache even when the project fails validation' do
        tip = make_tip(amount: 5)
        force_columns(tip, refunded_at: 1.day.ago)
        refresh_cache
        make_project_invalid

        tip.unrefund!

        expect(project.reload.available_amount_cache).to eq(project.available_amount)
      end

      # The available balance of a deleted project cannot be checked, so unrefund! refuses.
      it 'raises NoMethodError for a tip whose project was soft-deleted and changes nothing' do
        tip = tip_on_deleted_project(amount: 5, refunded_at: 1.day.ago)

        expect { tip.unrefund! }.to raise_error(NoMethodError, /available_amount/)
        expect(tip.reload).to be_refunded
        expect(tip.reopened_at).to be_nil
      end

      it 'raises InsufficientFunds when the project cannot cover the tip' do
        tip = make_tip(amount: 9_000)
        force_columns(tip, refunded_at: 1.day.ago)
        other = make_tip(amount: 9_000)
        expect(other).to be_decided

        expect { tip.unrefund! }.to raise_error(Tip::InsufficientFunds)
        expect(tip.reload).to be_refunded
        expect(tip.reopened_at).to be_nil
      end
    end
  end
end
