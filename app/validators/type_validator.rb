class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    required_type = options[:with]

    if value.is_a?(Array)
      unless value.all? { |i| i.instance_of?(required_type) }
        record.errors.add attribute, (options[:message] || "is not of class #{required_type}")
      end
    else
      unless value.instance_of?(required_type)
        record.errors.add attribute, (options[:message] || "is not of class #{required_type}")
      end
    end
  end
end
