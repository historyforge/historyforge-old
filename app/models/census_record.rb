class CensusRecord < ActiveRecord::Base

  include JsonData

  attribute :page_number
  attribute :line_number, as: :integer
  attribute :county
  attribute :city
  attribute :ward
  attribute :enum_dist
  attribute :street_prefix
  attribute :street_name
  attribute :street_suffix
  attribute :street_house_number
  attribute :dwelling_number
  attribute :family_id
  attribute :last_name
  attribute :first_name
  attribute :relation_to_head
  attribute :sex
  attribute :race
  attribute :age
  attribute :marital_status

  def name
    [first_name, last_name].join(' ')
  end

  def street_address
    [street_house_number, street_prefix, street_name, street_suffix].join(' ')
  end





end
