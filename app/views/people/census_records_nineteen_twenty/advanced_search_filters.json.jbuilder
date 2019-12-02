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
      json.name_has_any_term 'is one of'
      json.name_has_every_term 'is all of'
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
      json.pob_has_any_term 'is one of'
      json.pob_has_every_term 'is all of'
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
      json.profession_has_any_term 'is one of'
      json.profession_has_every_term 'is all of'
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
      json.industry_has_any_term 'is one of'
      json.industry_has_every_term 'is all of'
    end
    json.sortable 'industry'
  end

  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  AttributeBuilder.number   json, :page_number
  AttributeBuilder.enumeration json, Census1920Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.number json, :dwelling_number
  AttributeBuilder.number json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1920Record, :sex
  AttributeBuilder.enumeration json, Census1920Record, :race
  AttributeBuilder.age    json, :age
  AttributeBuilder.enumeration json, Census1920Record, :marital_status
  AttributeBuilder.text json, :pob
  AttributeBuilder.text json, :mother_tongue
  AttributeBuilder.text json, :pob_father
  AttributeBuilder.text json, :pob_mother
  AttributeBuilder.text json, :mother_tongue
  AttributeBuilder.text json, :mother_tongue_father
  AttributeBuilder.text json, :mother_tongue_mother
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.boolean json, :naturalized_alien
  AttributeBuilder.number json, :year_naturalized
  AttributeBuilder.enumeration json, Census1920Record, :employment
  AttributeBuilder.number json, :farm_schedule
  AttributeBuilder.enumeration json, Census1920Record, :owned_or_rented
  AttributeBuilder.enumeration json, Census1920Record, :mortgage

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end


end
