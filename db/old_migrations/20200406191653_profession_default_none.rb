class ProfessionDefaultNone < ActiveRecord::Migration[6.0]
  def change
    %w{1900 1910 1920 1930}.each do |year|
      change_column_default "census_#{year}_records", :profession, 'None'
    end
  end
end
