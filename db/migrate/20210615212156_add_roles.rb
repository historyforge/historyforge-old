class AddRoles < ActiveRecord::Migration[6.0]
  def change
    ['super user', 'editor', 'reviewer', 'administrator', 'developer', 'builder', 'census taker'].each do |role|
      Role.find_or_create_by name: role
    end
  end
end
