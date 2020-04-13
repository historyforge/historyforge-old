class Address
  attr_accessor :street_prefix, :street_name, :street_suffix, :city, :modern
  def initialize(attrs=Census1910Record.new)
    @street_prefix = attrs.street_prefix
    @street_name = attrs.street_name
    @street_suffix = attrs.street_suffix
    @city = attrs.city
  end

  def modernize
    StreetConversion.convert(self)
  end
end