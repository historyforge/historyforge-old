class ReformatPageNumber < ActiveRecord::Migration
  def change
    Census1910Record.find_each do |record|
      page = record.page_number
      if page =~ /B|b/
        record.page_side = 'B'
      else
        record.page_side = 'A'
      end
      record.page_no = page.to_i
      record.save validate: false
    end
  end
end
