class TipModifier < Struct.new(:name, :value)
  def self.find_in_message(message)
    return nil unless CONFIG["tip_modifiers"]

    modifier_name, modifier = CONFIG["tip_modifiers"].detect do |name,|
      message =~ /##{Regexp.escape(name)}/
    end

    if modifier_name
      new(modifier_name, modifier)
    else
      nil
    end
  end
end
