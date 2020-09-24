class SplitPobMotherTongue < ActiveRecord::Migration[6.0]
  def up
    terms = {
        "Eng English" => %w{England English},
        "Ger German" => %w{Germany German},
        "Hun Magyar" => %w{Hungary Magyar},
        "Hun Slovak" => %w{Hungary Slovak},
        "Ire English" => %w{Ireland English},
        "Ire Irish" => %w{Ireland Irish},
        "Ireland English" => %w{Ireland English},
        "Ireland Irish" => %w{Ireland Irish},
        "Ita Italian" => %w{Italy Italian},
        "Russ Polish" => %w{Russia Polish},
        "Russ Yiddish" => %w{Russia Yiddish},
        "Scot English" => %w{Scotland English},
        "Scot Scotch" => %w{Scotland Scotch},
        "Swed Swedish" => %w{Sweden Swedish},
        "Swit German" => %w{Switzerland German},
        "Wales Welsh" => %w{Wales Welsh}
    }

    pob_vocab = Vocabulary.find_by(name: 'Place of Birth')
    lang_vocab = Vocabulary.find_by(name: 'Language Spoken')
    terms.each do |original, parts|
      pob, language = parts
      pob_vocab.terms.where(name: pob).first_or_create
      lang_vocab.terms.where(name: language).first_or_create
    end

    %w[1900 1910 1920 1930].each do |year|
      model_class = "Census#{year}Record".constantize
      ['', '_father', '_mother'].each do |bit|
        pob_field = "pob#{bit}"
        language_field = "mother_tongue#{bit}"
        terms.each do |original, parts|
          pob, language = parts
          model_class.where(pob_field => original).each do |item|
            item[pob_field] = pob
            item[language_field] = language
            item.save
          end
        end
      end
    end
  end

  def down
  end
end
