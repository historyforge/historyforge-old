module CensusRecordsHelper

  def select_options_for(collection)
    [["blank", nil]] + collection.zip(collection)
  end

  def yes_no_choices
    [["blank", nil], ["yes", true], ["no", false]]
  end

end
