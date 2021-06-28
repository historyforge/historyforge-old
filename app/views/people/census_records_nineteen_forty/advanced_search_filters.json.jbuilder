json.filters do
  AttributeBuilder.collection json, Census1900Record,:locality_id, Locality.select_options

  AttributeBuilder.text(json, :name)
  AttributeBuilder.text(json, :pob)
  AttributeBuilder.text(json, :occupation)
  AttributeBuilder.text(json, :industry)
  AttributeBuilder.text   json, :first_name
  AttributeBuilder.text   json, :middle_name
  AttributeBuilder.text   json, :last_name

  json.census_scope do
    json.label 'Census Schedule'
    json.sortable 'census_scope'
  end

  AttributeBuilder.number   json, :page_number
  AttributeBuilder.enumeration json, Census1940Record, :page_side
  AttributeBuilder.number json, :line_number, sortable: false
  AttributeBuilder.text   json, :county
  AttributeBuilder.text   json, :city
  AttributeBuilder.number json, :ward
  AttributeBuilder.number json, :enum_dist
  AttributeBuilder.text   json, :street_address
  AttributeBuilder.text   json, :family_id
  AttributeBuilder.text   json, :relation_to_head
  AttributeBuilder.enumeration json, Census1940Record, :owned_or_rented
  AttributeBuilder.number json, :home_value
  AttributeBuilder.boolean json, :lives_on_farm
  AttributeBuilder.enumeration json, Census1940Record, :sex
  AttributeBuilder.enumeration json, Census1940Record, :race
  AttributeBuilder.age json, :age
  AttributeBuilder.enumeration json, Census1930Record, :marital_status
  AttributeBuilder.text json, :pob
  AttributeBuilder.boolean json, :foreign_born
  AttributeBuilder.number json, :year_immigrated
  AttributeBuilder.text json, :occupation_code
  AttributeBuilder.text json, :industry_code
  AttributeBuilder.text json, :worker_class_code
  AttributeBuilder.enumeration json, Census1940Record, :worker_class
  AttributeBuilder.text json, :farm_schedule

  json.notes do
    json.type 'text'
    json.label 'Notes'
    json.scopes do
      json.notes_cont 'contains'
    end
    json.sortable 'notes'
  end


end
