class OrderTracker
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ref, :type => String
  field :shop_uid, :type => String
  field :amount, :type => Float
  field :product_count, :type => Integer

  index({ ref: 1 }, { unique: true, name: "ref_index" })
  embeds_many :trackers

  def self.count_by_date
    map = %Q{
      function() {
        if (!this.trackers) {
          return false;
        }
        this.trackers.forEach(function(tracker) {
          day = Date.UTC(tracker.created_at.getFullYear(), tracker.created_at.getMonth(), tracker.created_at.getDate());
          emit({day: day, action: tracker.action}, {count: 1, date: day});
        });
      }
    }
    reduce = %Q{
      function(key, values) {
         var result = {count: 0, date: key['day']}
         values.forEach(function(v) {
           result.count += v['count'];
         });
         return result;
      }
    }
    self.map_reduce(map, reduce).out(inline: 1).group_by { |s| s['_id']['action']}
  end
end
