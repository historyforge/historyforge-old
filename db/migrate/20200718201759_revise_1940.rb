class Revise1940 < ActiveRecord::Migration[6.0]
  def change
    change_table :census_1940_records do |t|
      t.remove :pob_code, :pob_mother_code, :pob_father_code, :mother_tongue_code
      t.remove :education_code, :relation_code, :residence_1935_code, :no_work_code, :war_fought_code
      t.rename :profession, :occupation
      t.rename :profession_code, :occupation_code
      t.string :worker_class_code, after: :occupation_code
      t.string :industry_code, after: :occupation_code
    end
  end
end
