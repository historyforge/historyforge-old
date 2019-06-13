class AddDeveloperRole < ActiveRecord::Migration[4.2]
  def self.up
    Role.create(:name => 'developer')
  end

  def self.down
    Role.find_by_name('developer').destroy
  end
end
