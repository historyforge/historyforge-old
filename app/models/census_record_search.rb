class CensusRecordSearch

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :page, :s, :f, :fs, :g, :user, :c, :d, :paged, :per, :entity_class
  attr_writer :scoped
  delegate :any?, :present?, :each, :first, :last,
           :current_page, :total_pages, :limit_value,
           to: :scoped

  validates :t, presence: true

  def to_a
    @results ||= scoped.to_a.map {|row| CensusRecordPresenter.new(row, user) }
  end

  def ransack_params
    params = @s.inject({}) { |hash, value| hash[value[0].to_sym] = value[1]; hash }
    params
  end

  def sorts
    {c: c, d: d}
  end

  def scoped
    @scoped || begin
      rp = ransack_params
      rp[:reviewed_at_not_null] = 1 unless user
      @scoped = entity_class.ransack(rp).result
      @scoped = @scoped.page(page).per(per) if paged?
      @d = 'asc' unless %w{asc desc}.include?(@d)
      if @c
        if @c == 'census_scope'
          add_census_page_order_clause
        elsif @c == 'name'
          add_name_order_clause
        elsif @c == 'street_address'
          add_street_address_order_clause
        else
          add_regular_order_clause
        end
      end
    end

  end

  def add_street_address_order_clause
    @scoped = @scoped.order entity_class.send(:sanitize_sql, "street_name #{@d}, street_prefix #{@d}, street_house_number #{@d}, street_suffix #{@d}")
  end

  def add_census_page_order_clause
    @scoped = @scoped.order entity_class.send(:sanitize_sql, "ward #{@d}, enum_dist #{@d}, page_number #{@d}, page_side #{@d}, line_number #{@d}")
  end

  def add_name_order_clause
    @scoped = @scoped.order entity_class.send(:sanitize_sql, name_order_clause)
  end

  def add_regular_order_clause
    @scoped = @scoped.order entity_class.send(:sanitize_sql, "#{@c} #{@d}, #{name_order_clause}")
  end

  def self.generate(params:{}, user:nil, entity_class:nil, paged:true, per: 25)
    new user, entity_class, params[:s], params[:page], params[:f], params[:fs], params[:g], params[:c], params[:d], paged, per
  end

  def initialize(user, entity_class, scopes, page, fields, fieldsets, groupings, sort_col, sort_dir, paged, per)
    @user = user
    @entity_class = entity_class
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

      headers = ['ID']

      columns.each do |field|
        headers << I18n.t("simple_form.labels.census_record.#{field}", default: field.humanize)
      end

      csv << headers

      self.to_a.each do |row|
        row_results = [row.id]
        columns.each do |field|
          row_results << row.field_for(field)
        end
        csv << row_results
      end
    end

  end

  def name_order_clause
    "last_name #{@d}, first_name #{@d}, middle_name #{@d}"
  end

  def paged?
    !defined?(@paged) || paged
  end

  def columns
    return @columns if defined?(@columns)
    @columns = (fieldsets.map { |fs|
      method = "#{fs}_fields"
      respond_to?(method) ? Set.new(public_send(method)) : nil
    }.compact + [Set.new(f)]).reduce(&:union)
  end

  def fieldsets
    @fs.present? ? @fs : %w{census_scope}
  end

  def default_fields
    %w{}
  end

  def all_fields
    %w{}
  end

  def all_fieldsets
    %w{census_scope location}
  end

  def census_scope_fields
    %w{page_number page_side line_number}
  end

  def location_fields
    %w{county city ward enum_dist}
  end

end
