namespace :vocab do
  task build: :environment do
    Vocabulary.where(machine_name: 'relation_to_head').first_or_create { |model| model.name = 'Relation to Head' }
    Vocabulary.where(machine_name: 'pob').first_or_create { |model| model.name = 'Place of Birth' }
    Vocabulary.where(machine_name: 'language').first_or_create { |model| model.name = 'Language Spoken' }
    Vocabulary.where(machine_name: 'profession').first_or_create { |model| model.name = 'Profession' }
    Vocabulary.where(machine_name: 'profession_code').first_or_create { |model| model.name = 'Profession Code' }
    Vocabulary.where(machine_name: 'industry').first_or_create { |model| model.name = 'Industry' }
  end

  task terms: :environment do
    Vocabulary::DICTIONARY.each do |vocab, dict|
      vocabulary = Vocabulary.find_by(machine_name: vocab)
      dict.each do |year, fields|
        fields.each do |field|
          "Census#{year}Record".constantize.group(field).pluck(field).each do |option|
            vocabulary.terms.where(name: option).first_or_create
          end
        end
      end
    end
  end
end