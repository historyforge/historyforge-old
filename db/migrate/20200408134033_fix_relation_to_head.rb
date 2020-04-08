class FixRelationToHead < ActiveRecord::Migration[6.0]
  def change
    Term.where(vocabulary_id: 1).ransack(name_cont: '-').result.map(&:name).each do |term|
      [1900, 1910, 1920, 1930].each do |year|
        "Census#{year}Record".constantize.where(relation_to_head: term.titleize).update_all relation_to_head: term
      end
    end
  end
end
