class MatchThePeoples < ActiveRecord::Migration[6.0]
  def up
    change_column :people, :race, :string, limit: 12
    say_with_time "Matching 1900 census records to person records" do
      Census1900Record.find_each &:match_to_person!
    end
    say_with_time "Matching 1910 census records to person records" do
      Census1910Record.find_each &:match_to_person!
    end
    say_with_time "Matching 1920 census records to person records" do
      Census1920Record.find_each &:match_to_person!
    end
    say_with_time "Matching 1930 census records to person records" do
      Census1930Record.find_each &:match_to_person!
    end
  end

  def down
  end
end
