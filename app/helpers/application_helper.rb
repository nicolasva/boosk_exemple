module ApplicationHelper
  def link_stylesheet_iphone?(http_user_agent)
    result = true
    result = false if http_user_agent.scan(/^.{1,}(iPhone|iPad|iPod).{1,}(AppleWebKit).{1,}$/) == Array.new
    return result
  end

  def have_taxons_lists?
    taxonomy = Taxonomy.joins(:taxons, :shop).where('shops.uuid' => cookies["front_shop_id"]).count
    return taxonomy.to_i <= 1 ? false : true
  end

  def remaining_days(date)
    (date - Date.today.end_of_day.to_date).to_i
  end
end
