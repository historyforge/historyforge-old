namespace :census do
  task import: :environment do

    file = ENV['file']
    raise 'You must specify a filename like so: rake buildings:import file=path/to/file' if file.blank?

    Census1910Record.destroy_all

    require 'rubyXL'
    RubyXL::Parser.parse(file).worksheets.each do |sheet|
      sheet.each_with_index do |row, i|
        next unless row && row[0] && row[0].value
        if i == 0
          raise 'Does not look like a HistoryForge-Census template file' if row[0].value != 'Page No'
        else

          record = Census1910Record.new

          record.page_number = row[0].andand.value
          record.line_number = row[1].andand.value
          record.county = row[2].andand.value
          record.city = row[3].andand.value
          record.ward = row[4].andand.value
          record.enum_dist = row[5].andand.value
          record.street_prefix = row[6].andand.value
          record.street_name = row[7].andand.value
          record.street_suffix = row[8].andand.value
          record.street_house_number = row[9].andand.value
          record.dwelling_number = row[10].andand.value
          record.family_id = row[11].andand.value
          record.last_name = row[12].andand.value
          record.first_name = row[13].andand.value
          record.relation_to_head = row[14].andand.value
          record.sex = row[15].andand.value
          record.race = row[16].andand.value
          record.age = row[17].andand.value
          record.marital_status = row[18].andand.value
          record.years_married = row[19].andand.value
          record.num_children_born = row[20].andand.value
          record.num_children_alive = row[21].andand.value
          record.pob = row[22].andand.value
          record.pob_father = row[23].andand.value
          record.pob_mother = row[24].andand.value
          record.year_immigrated = row[25].andand.value
          record.naturalized_alien = row[26].andand.value
          record.language_spoken = row[27].andand.value
          record.profession = row[28].andand.value
          record.industry = row[29].andand.value
          record.employment = row[30].andand.value
          record.unemployed = row[31].andand.value =~ /Yes/
          record.unemployed_weeks_1909 = row[32].andand.value
          record.can_read = row[33].andand.value =~ /Yes/
          record.can_write = row[34].andand.value =~ /Yes/
          record.attended_school = row[35].andand.value =~ /Yes/
          record.owned_or_rented = row[36].andand.value
          record.mortgage = row[37].andand.value
          record.farm_or_house = row[38].andand.value
          record.num_farm_sched = row[39].andand.value
          record.civil_war_vet = row[40].andand.value =~ /Yes/
          record.blind = row[41].andand.value =~ /Yes/
          record.deaf_dumb = row[42].andand.value =~ /Yes/

          record.save!

        end

      end
    end


  end
end
