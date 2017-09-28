class BuildingSearch

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :page, :s, :f, :fs, :g, :user, :c, :d, :paged, :per, :unpeopled, :unreviewed, :uninvestigated, :people, :people_params, :expanded
  attr_writer :scoped
  delegate :any?, :present?, :each, :first, :last,
           :current_page, :total_pages, :limit_value,
           to: :scoped

  validates :t, presence: true

  def to_a
    return @results if defined?(@results)
    @results = scoped.to_a
    if @residents
      @results.each do |result|
        result.residents = @residents[result.id]
      end
    end
    @results
  end

  def as_json
    {
      buildings: to_a.map { |building| BuildingSerializer.new(building, root: false) },
      meta: pagination_dict(scoped)
    }
  end

  def ransack_params
    if @s.is_a?(String)
      @s = JSON.parse(@s)
    end
    params = @s.inject({}) { |hash, value| hash[value[0].to_sym] = value[1]; hash }
    params
  end

  def sorts
    {c: c, d: d}
  end

  def entity_class
    Building
  end

  def scoped
    @scoped || begin
      @f << 'investigate_reason' if uninvestigated
      rp = ransack_params
      rp[:reviewed_at_not_null] = 1 unless user
      @scoped = entity_class.includes(:building_type, :architects).ransack(rp).result
      add_order_clause
      @scoped = @scoped.without_residents if unpeopled
      @scoped = @scoped.where(reviewed_at: nil) if unreviewed
      @scoped = @scoped.where(investigate: true) if uninvestigated

      @scoped = @scoped.page(page).per(per)
      if expanded
        @scoped = @scoped.includes(:photos, :census_1900_records, :census_1910_records, :census_1920_records)
        if people.present?
          people_class = "Census#{people}Record".constantize
          people = people_class.where.not(reviewed_at: nil)
          if people_params.present?
            q = people_params.inject({}) {|hash, item|
              hash[item[0].to_sym] = item[1] if item[1].present?
              hash
            }
            people = people.ransack(q).result
          end
          if people.present?
            @residents = people.group_by(&:building_id)
            @scoped = @scoped.where(id: @residents.keys)
          end
        end

      end
      @scoped
    end

  end

  def add_order_clause
    @d = 'asc' unless %w{asc desc}.include?(@d)
    if @c
      if @c == 'street_address'
        @scoped = @scoped.order entity_class.send(:sanitize_sql, "address_house_number #{@d}, address_street_prefix #{@d}, address_street_name #{@d}, address_street_suffix #{@d}")
      elsif entity_class.columns.map(&:name).include?(@c)
        @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{@c} #{@d}")
      else
        # BOOM!
        # @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{entity_class.table_name}.data->>'#{@c}' #{@d}, #{name_order_clause}")
      end
    end
  end


  def self.generate(params:{}, user:nil, entity_class:nil, paged:true, per: 25)
    item = new user, params[:s], params[:page], params[:f], params[:fs], params[:g], params[:c], params[:d], paged, per
    item.people = params[:people] if params[:people]
    item.people_params = JSON.parse(params[:peopleParams]) if params[:peopleParams]
    item.unpeopled = true if params[:unpeopled]
    item.unreviewed = true if params[:unreviewed]
    item.uninvestigated = true if params[:uninvestigated]
    item
  end

  def initialize(user, scopes, page, fields, fieldsets, groupings, sort_col, sort_dir, paged, per)
    @user = user
    @page = page || 1
    @s = scopes || {}
    @f = fields || default_fields
    @fs = fieldsets || []
    @g = groupings || {}
    @c = sort_col || 'name'
    @d = sort_dir || 'asc'
    @paged = paged
    @per = per
  end

  def to_csv
    @paged = false
    require 'csv'
    CSV.generate do |csv|

      headers = []

      columns.each do |field|
        headers << I18n.t("simple_form.labels.building.#{field}", default: field.humanize)
      end

      csv << headers

      self.to_a.each do |row|
        row_results = []
        columns.each do |field|
          row_results << row.public_send(field)
        end
        csv << row_results
      end
    end

  end

  def paged?
    !defined?(@paged) || paged
  end

  def columns
    @columns ||= f
    # @columns ||= ([Set.new(f)] + fieldsets.map {|fs| Set.new public_send("#{fs}_fields") }).reduce(&:union)
  end

  def fieldsets
    @fs.present? ? @fs : %w{}
  end

  def default_fields
    %w{street_address city state building_type year_earliest}
  end

  def all_fields
    %w{name
       street_address city state postal_code
       year_earliest year_latest
       description annotations stories block_number
       building_type lining_type frame_type
       architects notes
    }
  end

  def all_fieldsets
    %w{}
  end

  def pagination_dict(object)
    info =  if object.total_pages < 2
              "All #{object.total_count} record(s)."
            else
              first = object.offset_value + 1
              last = object.last_page? ? object.total_count : object.offset_value + object.limit_value
              "#{first}-#{last} of #{object.total_count} records."
            end
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count,
      info: info
    }
  end
end
