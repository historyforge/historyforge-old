json.filters do
  AttributeBuilder.collection json, Census1900Record,:locality_id, Locality.select_options

  json.census_scope do
    json.label 'Census Schedule'
    json.sortable 'census_scope'
  end

  AttributeBuilder.text(json, :name)
  AttributeBuilder.text(json, :pob)
  AttributeBuilder.text(json, :profession)
  AttributeBuilder.text(json, :industry)

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
  AttributeBuilder.enumeration json, Census1920Record, :naturalized_alien
  AttributeBuilder.number json, :year_naturalized
  AttributeBuilder.enumeration json, Census1920Record, :employment
  AttributeBuilder.text json, :employment_code, klass: Census1920Record
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
