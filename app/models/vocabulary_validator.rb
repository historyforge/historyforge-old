class VocabularyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    vocab_name = options[:with] || options[:name] || attribute
    vocabulary = Vocabulary.by_name(vocab_name)
    unless vocabulary&.term_exists?(value)
      record.errors.add attribute, 'is not a valid term'
    end
  end
end