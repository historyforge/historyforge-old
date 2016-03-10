class CensusRecordSerializer < ActiveModel::Serializer

  attributes :id, :name, :year, :profession, :race, :sex, :age

end
