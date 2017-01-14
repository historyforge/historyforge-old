module CensusRecordsHelper

  def select_options_for(collection)
    [["blank", 'nil']] + collection.zip(collection)
  end

  def yes_no_choices
    [["blank", nil], ["yes", true], ["no", false]]
  end

  def prepare_blanks_for_1910_census(record)
    record.civil_war_vet     = 'nil' if record.civil_war_vet.nil?
    # record.unemployed        = 'nil' if record.unemployed.nil?
    record.naturalized_alien = 'nil' if record.naturalized_alien.nil?
    record.owned_or_rented   = 'nil' if record.owned_or_rented.nil?
    record.mortgage          = 'nil' if record.mortgage.nil?
    record.farm_or_house     = 'nil' if record.farm_or_house.nil?
    record.civil_war_vet     = 'nil' if record.civil_war_vet.nil?
    # record.can_read          = 'nil' if record.can_read.nil?
    # record.can_write         = 'nil' if record.can_write.nil?
    # record.attended_school   = 'nil' if record.attended_school.nil?
    # raise record.inspect
  end

end
