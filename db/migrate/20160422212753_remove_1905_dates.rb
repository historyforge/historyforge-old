class Remove1905Dates < ActiveRecord::Migration[4.2]
  def change
    Building.where(year_earliest: 1905).where('created_at>?', 10.days.ago).update_all year_earliest: nil
  end
end
