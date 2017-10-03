json.filters do
  json.census_scope do
    json.label 'Census Schedule'
    json.sortable 'census_scope'
  end

  json.name do
    json.type 'text'
    json.label 'Name'
    json.scopes do
      json.name_cont 'contains'
      json.name_not_cont 'does not contain'
    end
    json.sortable 'name'
  end

  json.pob do
    json.type 'text'
    json.label 'POB'
    json.scopes do
      json.pob_cont 'contains'
      json.pob_not_cont 'does not contain'
      json.pob_eq 'equals'
    end
    json.sortable 'pob'
  end

  json.profession do
    json.type 'text'
    json.label 'Profession'
    json.scopes do
      json.occupation_cont 'contains'
      json.occupation_not_cont 'does not contain'
      json.occupation_eq 'equals'
    end
    json.sortable 'occupation'
  end

  json.industry do
    json.type 'text'
    json.label 'Industry'
    json.scopes do
      json.industry_cont 'contains'
      json.industry_not_cont 'does not contain'
      json.industry_eq 'equals'
    end
    json.sortable 'industry'
  end

  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  AttributeBuilder.number   json, :page_number
  AttributeBuilder.enumeration json, Census1930Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1930Record, :owned_or_rented
  AttributeBuilder.number json, :home_value
  AttributeBuilder.boolean json, :has_radio
  AttributeBuilder.boolean json, :lives_on_farm
  AttributeBuilder.enumeration json, Census1930Record, :sex
  AttributeBuilder.enumeration json, Census1930Record, :race
  AttributeBuilder.age json, :age
  AttributeBuilder.enumeration json, Census1930Record, :marital_status
  AttributeBuilder.age json, :age_married
  AttributeBuilder.boolean json, :attended_school
  AttributeBuilder.boolean json, :can_read_write
  AttributeBuilder.text json, :pob
  AttributeBuilder.text json, :pob_code
  AttributeBuilder.text json, :pob_father
  AttributeBuilder.text json, :pob_father_code
  AttributeBuilder.text json, :pob_mother
  AttributeBuilder.text json, :pob_mother_code
  AttributeBuilder.text json, :mother_tongue
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.boolean json, :naturalized_alien
  AttributeBuilder.boolean json, :can_speak_english
  AttributeBuilder.text json, :occupation_code
  AttributeBuilder.text json, :worker_class
  AttributeBuilder.boolean json, :worked_yesterday
  AttributeBuilder.text json, :unemployment_line
  AttributeBuilder.boolean json, :veteran
  AttributeBuilder.text json, :war_fought
  AttributeBuilder.text json, :farm_schedule
  AttributeBuilder.boolean json, :provisional
  AttributeBuilder.boolean json, :taker_error

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end


end
