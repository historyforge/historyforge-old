namespace :vocab do
  task build: :environment do
    Vocabulary.where(machine_name: 'relation_to_head').first_or_create { |model| model.name = 'Relation to Head' }
    Vocabulary.where(machine_name: 'pob').first_or_create { |model| model.name = 'Place of Birth' }
    Vocabulary.where(machine_name: 'language').first_or_create { |model| model.name = 'Language Spoken' }
    Vocabulary.where(machine_name: 'profession').first_or_create { |model| model.name = 'Profession' }
    Vocabulary.where(machine_name: 'profession_code').first_or_create { |model| model.name = 'Profession Code' }
    Vocabulary.where(machine_name: 'industry').first_or_create { |model| model.name = 'Industry' }
    Vocabulary.where(machine_name: 'war_fought').first_or_create { |model| model.name = 'War Fought' }
  end

  task terms: :environment do
    vocabs = {
        relation_to_head: {
            1900 => ['relation_to_head'],
            1910 => ['relation_to_head'],
            1920 => ['relation_to_head'],
            1930 => ['relation_to_head']
        },
        war_fought: {
            1930 => ['war_fought']
        },
        industry: {
            1900 => ['industry'],
            1910 => ['industry'],
            1920 => ['industry'],
            1930 => ['industry']
        },
        profession: {
            1900 => ['profession'],
            1910 => ['profession'],
            1920 => ['profession'],
            1930 => ['profession']
        },
        profession_code: {
            1930 => ['profession_code']
        },
        language: {
            1900 => ['language_spoken'],
            1910 => ['language_spoken'],
            1920 => ['mother_tongue', 'mother_tongue_father', 'mother_tongue_mother'],
            1930 => ['mother_tongue']
        },
        pob: {
            1900 => ['pob', 'pob_father', 'pob_mother'],
            1910 => ['pob', 'pob_father', 'pob_mother'],
            1920 => ['pob', 'pob_father', 'pob_mother'],
            1930 => ['pob', 'pob_father', 'pob_mother']
        }
    }
    vocabs.each do |vocab, dict|
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