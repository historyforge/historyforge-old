class CleanMiddleNames < ActiveRecord::Migration[6.0]
  def up
    Census1900Record.ransack(middle_name_cont: '.').result.map &:save
    Census1910Record.ransack(middle_name_cont: '.').result.map &:save
    Census1920Record.ransack(middle_name_cont: '.').result.map &:save
    Census1930Record.ransack(middle_name_cont: '.').result.map &:save
  end
  def down

  end
end
