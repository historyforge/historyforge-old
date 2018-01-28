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
      json.profession_cont 'contains'
      json.profession_not_cont 'does not contain'
      json.profession_eq 'equals'
    end
    json.sortable 'profession'
  end

  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  AttributeBuilder.number json, :page_number
  AttributeBuilder.enumeration json, Census1900Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1900Record, :sex
  AttributeBuilder.enumeration json, Census1900Record, :race
  AttributeBuilder.age    json, :age
  AttributeBuilder.number json, :birth_year
  AttributeBuilder.number json, :birth_month
  AttributeBuilder.enumeration json, Census1900Record, :marital_status
  AttributeBuilder.number json, :years_married
  AttributeBuilder.number json, :num_children_born
  AttributeBuilder.number json, :num_children_alive
  AttributeBuilder.text json, :pob
  AttributeBuilder.text json, :pob_father
  AttributeBuilder.text json, :pob_mother
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.number json, :year_in_us
  AttributeBuilder.boolean json, :naturalized_alien
  # AttributeBuilder.text json, :language_spoken
  # AttributeBuilder.text json, :profession
  AttributeBuilder.text json, :industry
  # AttributeBuilder.enumeration json, Census1900Record, :employment
  AttributeBuilder.number json, :unemployed_months
  # AttributeBuilder.number json, :unemployed_weeks_1909
  AttributeBuilder.boolean json, :can_read
  AttributeBuilder.boolean json, :can_write
  AttributeBuilder.number json, :attended_school
  AttributeBuilder.boolean json, :can_speak_english
  AttributeBuilder.enumeration json, Census1900Record, :owned_or_rented
  AttributeBuilder.enumeration json, Census1900Record, :mortgage
  AttributeBuilder.enumeration json, Census1900Record, :farm_or_house
  AttributeBuilder.number json, :farm_schedule
  # AttributeBuilder.boolean json, :blind
  # AttributeBuilder.enumeration json, Census1900Record, :civil_war_vet
  # AttributeBuilder.boolean json, :deaf_dumb
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
