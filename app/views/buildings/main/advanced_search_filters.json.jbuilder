json.filters do

  AttributeBuilder.text       json, :street_address

  json.city do
    json.type 'text'
    json.label 'City'
    json.scopes do
      json.city_cont 'contains'
      json.city_not_cont 'does not contain'
      json.city_eq 'equals'
    end
    json.sortable 'city'
  end

  AttributeBuilder.collection json, Building, :building_types_id, BuildingType.order(:name).map {|item| [ item.name.capitalize, item.id ]}
  AttributeBuilder.collection json, Building, :lining_type_id, ConstructionMaterial.order(:name).map {|item| [ item.name.capitalize, item.id ]}
  AttributeBuilder.collection json, Building, :frame_type_id, ConstructionMaterial.order(:name).map {|item| [ item.name.capitalize, item.id ]}
  AttributeBuilder.text       json, :block_number
  json.as_of_year do
    json.type 'number'
    json.label 'As of Year'
    json.scopes do
      json.as_of_year_eq 'equals'
    end
  end

  AttributeBuilder.time       json, :year_earliest
  AttributeBuilder.time       json, :year_latest
  AttributeBuilder.number     json, :stories
  AttributeBuilder.text       json, :description
  AttributeBuilder.text       json, :annotations
  AttributeBuilder.collection json, Architect, :architects_id, Architect.order(:name).map {|item| [item.name, item.id] }

end
