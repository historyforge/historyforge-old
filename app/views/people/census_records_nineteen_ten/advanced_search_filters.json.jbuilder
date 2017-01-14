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
  AttributeBuilder.enumeration json, Census1910Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1910Record, :sex
  AttributeBuilder.enumeration json, Census1910Record, :race
  AttributeBuilder.age    json, :age
  AttributeBuilder.enumeration json, Census1910Record, :marital_status
  AttributeBuilder.number json, :years_married
  AttributeBuilder.number json, :num_children_born
  AttributeBuilder.number json, :num_children_alive
  AttributeBuilder.text json, :pob
  AttributeBuilder.text json, :pob_father
  AttributeBuilder.text json, :pob_mother
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.boolean json, :naturalized_alien
  AttributeBuilder.text json, :language_spoken
  AttributeBuilder.text json, :profession
  AttributeBuilder.text json, :industry
  AttributeBuilder.enumeration json, Census1910Record, :employment
  AttributeBuilder.boolean json, :unemployed
  AttributeBuilder.number json, :unemployed_weeks_1909
  AttributeBuilder.boolean json, :can_read
  AttributeBuilder.boolean json, :can_write
  AttributeBuilder.boolean json, :attended_school
  AttributeBuilder.enumeration json, Census1910Record, :owned_or_rented
  AttributeBuilder.enumeration json, Census1910Record, :farm_or_house
  AttributeBuilder.boolean json, :blind
  AttributeBuilder.enumeration json, Census1910Record, :civil_war_vet
  AttributeBuilder.boolean json, :deaf_dumb

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end


end
