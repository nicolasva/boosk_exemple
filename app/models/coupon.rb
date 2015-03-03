class Coupon

  def self.all
    $redis.keys("coupon*")
  end

  def self.find(coupon)
    $redis.keys("coupon:#{coupon}")
  end

  def self.generate(n)
    1.upto(n) do
      coupon = (0...10).map{65.+(rand(25)).chr}.join
      $redis.set("coupon:#{coupon}", coupon)
    end
  end

  def self.destroy(coupon)
    $redis.del("coupon:#{coupon}") unless self.find(coupon).empty?
  end

  def self.destroy_all
    $redis.del(self.all) unless self.all.empty?
  end

end
