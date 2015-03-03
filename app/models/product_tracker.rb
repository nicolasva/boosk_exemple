class ProductTracker
  include Mongoid::Document

  ACTIONS = ['like','tweet','want','have','pin','cart','order']

  field :ref, :type => String
  field :shop_uid, :type => String
  field :name, :type => String

  index({ ref: 1 }, { unique: true, name: "ref_index" })
  embeds_many :trackers  

  
  def self.top_by_action(action)
    map = %Q{
      function() {
        if (!this.trackers) {
          return;
        }
        p = this
        this.trackers.forEach(function(tracker) {
          if (tracker['action'] == "#{action}") {
            emit(p.ref, {ref: p.ref, count: 1});
          }
        });
      }
    }
    reduce = %Q{
      function(key, values) {
        return {count: values.length, ref: key};
      }
    }
    self.map_reduce(map, reduce).out(inline: 1).sort_by {|p| p["value"]["count"]}.reverse
  end


  def self.count_by_action
    map = %Q{
      function() {
        if (!this.trackers) {
          return;
        }
        p = this
        this.trackers.forEach(function(tracker) {
          emit(tracker.action, {count: 1, action: tracker.action});
        });
      }
    }
    reduce = %Q{
      function(key, values) {
        return {count: values.length, action: key};
      }
    }
    self.map_reduce(map, reduce).out(inline: 1)
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
