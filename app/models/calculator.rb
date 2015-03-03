class Calculator < ActiveRecord::Base
  include Preferences::Preferable

  belongs_to :shipping_method

  def compute(something=nil)
    raise(NotImplementedError, 'please use concrete calculator')
  end

  def self.description
    'Base Calculator'
  end

end