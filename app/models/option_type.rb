class OptionType < ActiveRecord::Base
  attr_accessible :name, :value, :shop_id
  belongs_to :shop
  has_and_belongs_to_many :product_variants

  validates :name, :value, :presence => true

  scope :by_key, lambda { |key|
    where("name = ?", key)
  }

  def self.group_by_key
    self.all.group_by(&:name).collect {|name,values| {:type => name, :values => values}}
  end

  def self.create_by_key(params, shop_id)
    option_types = []
    params[:value].each do |value|
      option_types << {:name => params[:name], :shop_id => shop_id, :value => value}
    end
    option_types = self.create(option_types)
    option_types.group_by(&:name).collect {|name,values| {:type => name, :values => values}}
  end


  def self.update_by_key(option_type, shop_id)
    @option_types = []
    option_type[:option].each do |option|
      @option_type = self.find_or_initialize_by_id(option[:id])
      @option_type.name = option_type[:name]
      @option_type.shop_id = shop_id
      @option_type.value = option[:value]
      @option_types << @option_type if @option_type.save!
    end
    @option_types.group_by(&:name).collect {|name,values| {:type => name, :values => values}}
  end
end
