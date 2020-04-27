class MergeBuilding
  def initialize(source, target)
    @source, @target = source, target
  end

  def perform
    merge_census_records
    merge_photographs
  end

  private

  def merge_census_records
    @source.with_residents.residents.each do |record|
      record.building = @target
      record.save
    end
  end

  def merge_photographs
    @source.photos.each do |photo|
      photo.buildings << @target
    end
  end
end