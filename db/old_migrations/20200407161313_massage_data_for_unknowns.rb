class MassageDataForUnknowns < ActiveRecord::Migration[6.0]
  def change
    Census1920Record.where(race: 'M').each do |row|
      row.race = 'Mu'
      row.save
    end
    Census1900Record.where(age: -1).each do |row|
      row.age = 999
      row.save
    end
    Census1910Record.where(age: -1).each do |row|
      row.age = 999
      row.save
    end
    Census1920Record.where(age: -1).each do |row|
      row.age = 999
      row.save
    end
    Census1930Record.where(age: -1).each do |row|
      row.age = 999
      row.save
    end

    Census1900Record.where(year_immigrated: -1).each do |row|
      row.year_immigrated = 999
      row.save
    end
    Census1910Record.where(year_immigrated: -1).each do |row|
      row.year_immigrated = 999
      row.save
    end
    Census1920Record.where(year_immigrated: -1).each do |row|
      row.year_immigrated = 999
      row.save
    end
    Census1930Record.where(year_immigrated: -1).each do |row|
      row.year_immigrated = 999
      row.save
    end

    Census1920Record.where(year_naturalized: -1).each do |row|
      row.year_naturalized = 999
      row.save
    end
  end
end
