class CensusRecord1920Search < CensusRecordSearch
  def default_fields
    %w{name sex race age marital_status relation_to_head profession industry pob street_address}
  end

  def all_fields
    %w[page_number page_side line_number county city ward enum_dist street_address dwelling_number family_id
      name relation_to_head sex race age marital_status
      pob pob_father pob_mother
      mother_tongue mother_tongue_father mother_tongue_mother
      foreign_born year_immigrated
      naturalized_alien
      profession industry employment
      owned_or_rented mortgage farm_or_house
      notes latitude longitude
    ]
  end
end
