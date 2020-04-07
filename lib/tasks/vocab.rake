namespace :vocab do
  task build: :environment do
    Vocabulary.where(machine_name: 'relation_to_head').first_or_create { |model| model.name = 'Relation to Head' }
    Vocabulary.where(machine_name: 'pob').first_or_create { |model| model.name = 'Place of Birth' }
    Vocabulary.where(machine_name: 'language').first_or_create { |model| model.name = 'Language Spoken' }
    # Vocabulary.where(machine_name: 'profession').first_or_create { |model| model.name = 'Profession' }
    # Vocabulary.where(machine_name: 'industry').first_or_create { |model| model.name = 'Industry' }
  end

  task terms: :environment do
    Term.delete_all
    Vocabulary::DICTIONARY.each do |vocab, dict|
      vocabulary = Vocabulary.find_by(machine_name: vocab)
      dict.each do |year, fields|
        fields.each do |field|
          model_class = "Census#{year}Record".constantize
          model_class.group(field).pluck(field).compact.each do |option|
            formatted_option = option.squish.titleize
            vocabulary.terms.where(name: formatted_option).first_or_create
            if formatted_option != option
              model_class.where(field => option).update_all field => formatted_option
            end
          end
        end
      end
    end
  end

  task ocodes: :environment do
    # https://stevemorse.org/census/ocodes.htm
    require 'open-uri'
    html = Nokogiri::HTML open("https://stevemorse.org/census/ocodes.htm").read
    occ_codes = get_codes_from_select_options html, 'occupation'
    occ_codes.each do |code|
      Occupation1930Code.where(code: code[0]).first_or_create { |model| model.name = code[1] }
    end
    level_codes = get_codes_from_select_options html, 'level'
    level_codes.each do |code|
      Occupation1930Code.where(code: code[0]).first_or_create { |model| model.name = code[1] }
    end
    industry_codes = get_codes_from_select_options html, 'industry'
    industry_codes.each do |code|
      Industry1930Code.where(code: code[0]).first_or_create { |model| model.name = code[1] }
    end
  end

  task load_ocodes: :environment do
    Census1930Record.find_each do |row|
      row.handle_profession_code
      row.save
    end
  end

  def get_codes_from_select_options(html, name)
    options = html.css("select[name=#{name}Code] option")
    options.map { |option| [option.text(), option['value']] }
  end
end