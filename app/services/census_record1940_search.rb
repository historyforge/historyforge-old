class CensusRecord1940Search < CensusRecordSearch
  def default_fields
    %w{name sex race age marital_status relation_to_head profession industry pob street_address}
  end

  def all_fields
    %w[page_number page_side line_number county city ward enum_dist street_address family_id
      name relation_to_head sex race age marital_status
      attended_school grade_completed education_code
      pob pob_code foreign_born naturalized_alien
      residence_1935_town residence_1935_county residence_1935_state
      residence_1935_farm residence_1935_code
      private_work public_work seeking_work had_job
      no_work_reason no_work_code private_hours worked unemployed_weeks
      profession industry worker_class profession_code
      owned_or_rented home_value lives_on_farm
      notes latitude longitude
    ]
  end
end
