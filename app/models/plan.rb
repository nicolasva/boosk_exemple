class Plan < ActiveRecord::Base
  has_many :users, :dependent => :destroy

  def nb_free_months
    (((12*monthly_price)-yearly_price)/monthly_price).round
  end
end
