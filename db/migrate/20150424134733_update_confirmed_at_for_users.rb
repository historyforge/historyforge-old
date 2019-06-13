class UpdateConfirmedAtForUsers < ActiveRecord::Migration[4.2]
  def up   
     execute("UPDATE users SET confirmed_at = NOW()")
  end
end
