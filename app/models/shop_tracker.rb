class ShopTracker
  include Mongoid::Document

  field :ref, :type => String

  embeds_many :trackers

  index({ ref: 1 }, { unique: true, name: "ref_index" })

  def self.get_actions(ref, action)
    self.find_by(:ref => ref).trackers.where(:action => action)
  end

  def self.count_by_date
    map = %Q{
      function() {
        if (!this.trackers) {
          return;
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
