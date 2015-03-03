module PaymentsHelper
  def ogone_subscription_form(plan)
    haml_tag :form, method: "post", action: OGONE["payment_url"] do
      haml_tag :input, type: "hidden", name: "PSPID", value: OGONE["PSPID"]
      haml_tag :input, type: "submit", value: t(:go), class: "btn choose"
    end
  end
end