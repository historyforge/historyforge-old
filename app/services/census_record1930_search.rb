class CensusRecord1930Search < CensusRecordSearch
  def default_fields
    %w{name sex race age marital_status relation_to_head profession industry pob street_address}
  end

  def all_fields
    %w[page_number page_side line_number county city ward enum_dist street_address dwelling_number family_id
      name relation_to_head sex race age marital_status age_married
      attended_school can_read_write can_speak_english
      pob pob_father pob_mother
      mother_tongue
      foreign_born year_immigrated
      naturalized_alien
      profession industry
      owned_or_rented home_value has_radio lives_on_farm
      veteran war_fought worker_class worked_yesterday unemployment_line
      notes latitude longitude
    ]
  end
end
