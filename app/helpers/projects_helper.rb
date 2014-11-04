module ProjectsHelper

  def shield_btc_amount amount
    btc_amount = to_btc amount
    "%.#{9 - btc_amount.to_i.to_s.length}f Ƀ" % btc_amount
  end

  def shield_color project
    last_tip = project.tips.order(:created_at).last
    if last_tip.nil? || (Time.now - last_tip.created_at > 30.days)
      'red'
    elsif (Time.now - last_tip.created_at > 7.days)
      'yellow'
    elsif (Time.now - last_tip.created_at > 1.day)
      'yellowgreen'
    else
      'green'
    end
  end

  def pretty_project_path project
    "/#{project.host}/#{project.full_name}"
  end

  def pretty_project_edit_path project
    "#{pretty_project_path project}/edit"
  end

  def pretty_project_decide_tip_amounts_path project
    "#{pretty_project_path project}/decide_tip_amounts"
  end

  def pretty_project_tips_path project
    "#{pretty_project_path project}/tips"
  end

  def pretty_project_deposits_path project
    "#{pretty_project_path project}/deposits"
  end

  def pretty_project_url project
    root_url.gsub(/\/$/,'') + pretty_project_path(project)
  end

  def shield_url project
    project_url project, format: :svg
  end
end
