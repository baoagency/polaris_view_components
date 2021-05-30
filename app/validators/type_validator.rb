class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "is not of class #{options[:with]}") unless value.class == options[:with]
  end
end
