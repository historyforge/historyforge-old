namespace :ipums do
  task load_1910: :environment do
    filename = '/' + File.join('mnt', 'c', 'Users', 'owner', 'Downloads', 'usa_00004.csv')
    File.open(filename, 'r') do |file|
      csv = CSV.new(file, headers: true)

      while row = csv.shift
        record = IpumsRecord.find_or_initialize_by(histid: row['HISTID'])
        record.data = row
        record.serial = row['SERIAL'].to_i
        record.year = row['YEAR'].to_i
        record.save
      end
    end
  end


  task dictionary: :environment do
    dict = {}
    file = Rails.root.join('db', 'ipums.xml')
    xml = Nokogiri::XML(File.open(file).read)
    xml.css('var').each do |var|
      values = {}
      var.css('catgry').each do |cat|
        key = cat.css('catValu').first.content
        val = cat.css('labl').first.content
        values[key] = val
      end
      dict[var['ID']] = values
    end
    File.open(Rails.root.join('db', 'ipums.json'), 'w') do |file|
      file.write dict.to_json
    end
  end
end
