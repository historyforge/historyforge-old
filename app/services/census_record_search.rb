class CensusRecordSearch

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :page, :s, :f, :fs, :g, :user, :sort, :paged, :per, :entity_class, :from, :to, :scope
  attr_writer :scoped
  delegate :any?, :present?, :each, :first, :last,
           :current_page, :total_pages, :limit_value,
           to: :scoped

  validates :t, presence: true

  def to_a
    @results ||= scoped.to_a.map {|row| CensusRecordPresenter.new(row, user) }
  end

  def ransack_params
    @s = @s.to_unsafe_hash if @s.respond_to?(:to_unsafe_hash)
    @s.inject({}) { |hash, value| hash[value[0].to_sym] = value[1]; hash }
  end

  def scoped
    @scoped || begin
      rp = ransack_params
      rp[:reviewed_at_not_null] = 1 unless user
      @scoped = entity_class.ransack(rp).result
      if from && to
        @scoped = @scoped.offset(from).limit(to.to_i - from.to_i)
      elsif paged?
        @scoped = @scoped.page(page).per(per)
      end
      @scoped = @scoped.includes(:building) if f.include?('latitude') || f.include?('longitude')
      @scoped = @scoped.unhoused if unhoused?
      @scoped = @scoped.unreviewed if unreviewed?
      @scoped = @scoped.unmatched if unmatched?

      add_sorts
    end

  end

  def add_sorts
    order = []
    streeted = false
    censused = false
    sort&.each do |key, sort_unit|
      Rails.logger.info sort_unit
      col, dir = sort_unit.values
      if col == 'name'
        order << name_order_clause(dir)
      elsif col =~ /street/
        order << street_address_order_clause(dir) unless streeted
        streeted = true
      elsif %w{ward enum_dist page_number page_size line_number}.include?(col)
        order << census_page_order_clause(dir) unless censused
        censused = true
      elsif entity_class.columns.map(&:name).include?(col)
        order << "#{col} #{dir}"
      end
    end
    order << name_order_clause('asc') if sort.blank?
    @scoped = @scoped.order entity_class.send(:sanitize_sql, order.join(', '))
  end

  def street_address_order_clause(dir)
    "street_name #{dir}, street_prefix #{dir}, street_house_number #{dir}, street_suffix #{dir}"
  end

  def census_page_order_clause(dir)
    "ward #{dir}, enum_dist #{dir}, page_number #{dir}, page_side #{dir}, line_number #{dir}"
  end

  # def add_name_order_clause
  #   @scoped = @scoped.order entity_class.send(:sanitize_sql, name_order_clause)
  # end

  def name_order_clause(dir)
    "last_name #{dir}, first_name #{dir}, middle_name #{dir}"
  end

  def self.generate(params: {}, user:nil, entity_class:nil, paged:true, per: 25)
    new user, entity_class, params[:s], params[:page], params[:f], params[:fs], params[:g], params[:sort], paged, per, params[:from], params[:to]
  end

  def initialize(user, entity_class, scopes, page, fields, fieldsets, groupings, sort, paged, per, from, to)
    @user = user
    @entity_class = entity_class
    @page = page || 1
    @s = scopes || {}
    @f = fields || default_fields
    @fs = fieldsets || []
    @g = groupings || {}
    @sort = sort
    @paged = paged
    @per = per
    @from = from
    @to = to
  end

  def to_csv(csv)
    @paged = false
    require 'csv'

    headers = ['ID']
    columns.each do |field|
      headers << I18n.t("simple_form.labels.census_record.#{field}", default: field.humanize)
    end
    csv << CSV.generate_line(headers)

    to_a.each do |row|
      row_results = [row.id]
      columns.each do |field|
        row_results << row.field_for(field)
      end
      csv << CSV.generate_line(row_results)
    end
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
    @columns = @columns.to_a
    @columns << 'id'
    @columns
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

  def is_default_field?(field)
    default_fields.include?(field.to_s)
  end

  def unhoused?
    @scope == :unhoused
  end

  def unreviewed?
    @scope == :unreviewed
  end

  def unmatched?
    @scope == :unmatched
  end

  def column_def
    columns.map { |column| column_config(column) }
  end

  def column_config(column)
    options = {
        headerName: I18n.t("simple_form.labels.census_record.#{column}", default: column.humanize),
        field: column,
        resizable: true
    }
    options[:headerName] = 'Actions' if column == 'id'
    options[:pinned] = 'left' if %w{id name}.include?(column)
    options[:cellRenderer] = 'actionCellRenderer' if column == 'id'
    options[:cellRenderer] = 'nameCellRenderer' if column == 'name'
    options[:width] = 50 if census_scope_fields.include?(column) || %w{race age sex marital_status}.include?(column)
    options[:width] = 60 if %w{id ward enum_dist dwelling_number family_id}.include?(column)
    options[:width] = 130 if %w{profession industry}.include?(column)
    options[:width] = 160 if %w{name street_address notes profession}.include?(column)
    options[:width] = 250 if %w{coded_occupation_name coded_industry_name}.include?(column)
    options[:sortable] = true unless column == 'id'
    options
  end

  def row_data(records)
    records.map do |record|
      columns.inject({id: record.id}) do |hash, column|
        value = record.field_for(column)
        if column == 'name'
          value = { name: value, reviewed: record.reviewed? }
        end
        hash[column] = value
        hash
      end
    end
  end
end
