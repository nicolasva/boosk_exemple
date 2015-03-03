module ShopsHelper
  def create_menu taxons, t_father=1, dom=""
    if t_father == 1
      dom = "
        <ul class='taxonomies_list'>
          <li id='home'>
            <a href='facebook/#/shops/#{cookies[:shop_id]}'>"+ t(:home, scope: [:views, :menu]) +"</a>
          </li>
      "
    end

    taxons.each do |taxon|
      if taxon.parent_id == t_father
        dom += "<li class='taxon' data-id='#{taxon.id}'>
          <a href='#'>#{taxon.name}</a>
        "
        taxons_child = get_children(taxon, taxons)
        unless taxons_child.empty?
          dom += "<ul class='taxon children-menu'>"
          dom += create_menu taxons, taxon.id
          dom += "</ul>"
        end
        dom += "</li>"
      end
    end  

    if t_father == 1
      dom += "</ul> "
    end
    return dom
  end

  def get_children taxon, taxons
    tab = []
    taxons.each do |t|
      if taxon.id == t.parent_id
        tab.push t
      end
    end
    return tab
  end
end
