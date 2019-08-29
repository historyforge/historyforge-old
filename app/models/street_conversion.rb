class StreetConversion < ApplicationRecord
  def description
    from = [from_prefix, from_name, from_suffix, from_city].select(&:present?).join(' ')
    to   = [to_prefix,   to_name,   to_suffix,   to_city].select(&:present?).join(' ')
    "#{from} => #{to}"
  end

  def matches?(address)
    needed_matches = [from_prefix, from_name, from_suffix, from_city].select(&:present?).size
    matches = 0
    matches += 1 if from_prefix.present? && address.street_prefix == from_prefix
    matches += 1 if from_name.present? && address.street_name == from_name
    matches += 1 if from_suffix.present? && address.street_suffix == from_suffix
    matches += 1 if from_city.present? && address.city == from_city
    matches == needed_matches
  end

  def convert(address)
    address.street_prefix = to_prefix if to_prefix.present?
    address.street_name = to_name if to_name.present?
    address.street_suffix = to_suffix if to_suffix.present?
    address.city = to_city if to_city.present?
    address
  end

  def self.convert(address)
    converter = all.detect { |record| record.matches?(address) }
    converter ? converter.convert(address) : address
  end
end

# def convert_street_name
#   if street_name == 'Mill'
#     'Court'
#   elsif street_name == 'Railroad' || street_name == 'Neahga'
#     'Lincoln'
#   elsif street_name == 'Boulevard' || street_name == 'Glenwood'
#     'Old Taughannock'
#   elsif street_name == 'Humboldt'
#     'Floral'
#   elsif street_name == 'Mechanic'
#     'Hillview'
#   elsif street_name == 'Tioga' && street_prefix == 'S'
#     'Turner'
#   elsif street_name == 'Wheat'
#     'Cleveland'
#   else
#     street_name
#   end
# end
#
# def convert_street_suffix
#   if street_name == 'Railroad'
#     'Ave'
#   elsif street_name == 'Boulevard' || street_name == 'Glenwood'
#     'Blvd'
#   elsif street_name == 'Mechanic' || (street_name == 'Tioga' && street_prefix == 'S')
#     'Pl'
#   elsif street_name == 'Humboldt' || street_name == 'Wheat'
#     'Avenue'
#   else
#     street_suffix
#   end
# end
#
# def convert_street_prefix
#   if street_name == 'Tioga' || street_prefix == 'S'
#     nil
#   else
#     street_prefix
#   end
# end
