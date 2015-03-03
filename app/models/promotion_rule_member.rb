class PromotionRuleMember < ActiveRecord::Base
  belongs_to :promotion_rule
  belongs_to :item, :polymorphic => true
end