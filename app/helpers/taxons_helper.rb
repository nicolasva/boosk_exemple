module TaxonsHelper

  def render_taxon taxon
    haml_tag :p do
      haml_tag :strong, taxon.name
      unless taxon.root?
        haml_tag :span, class: "actions" do
          haml_concat link_to 'Edit', edit_shop_taxonomy_taxon_path(taxon.taxonomy.shop, taxon.taxonomy, taxon), class: "btn btn-mini"
          haml_concat link_to 'Destroy', shop_taxonomy_taxon_path(taxon.taxonomy.shop, taxon.taxonomy, taxon), confirm: 'Are you sure?', method: :delete, class: "btn btn-mini btn-danger"
        end
      end
      unless taxon.leaf?
        haml_tag :ul do
          taxon.children.each do |child|
            haml_tag :li do
              render_taxon child
            end
          end
        end
      end
    end
  end

end