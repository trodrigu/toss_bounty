defmodule TossBounty.StripeProcessing.MockStripeCustomerCreator do
  @behaviour TossBountyWeb.CustomerController.Behaviour

  def create(_attrs) do
    {:ok,
     %Stripe.Customer{
       account_balance: 0,
       business_vat_id: nil,
       created: 1_517_111_254,
       currency: nil,
       default_source: "card_1Bp78kC3eQKO1wmdwgFEbDZ6",
       delinquent: false,
       description: nil,
       discount: nil,
       email: nil,
       id: "cus_CDYFyxfPuKA48s",
       livemode: false,
       metadata: %{},
       object: "customer",
       shipping: nil,
       sources: %Stripe.List{
         data: [
           %Stripe.Card{
             address_city: nil,
             address_country: nil,
             address_line1: nil,
             address_line1_check: nil,
             address_line2: nil,
             address_state: nil,
             address_zip: nil,
             address_zip_check: nil,
             brand: "Visa",
             country: "US",
             customer: "cus_CDYFyxfPuKA48s",
             cvc_check: nil,
             dynamic_last4: nil,
             exp_month: 8,
             exp_year: 2019,
             fingerprint: "y5OqH4wjN3g3vni4",
             funding: "credit",
             id: "card_1Bp78kC3eQKO1wmdwgFEbDZ6",
             last4: "4242",
             metadata: %{},
             name: nil,
             object: "card",
             recipient: nil,
             tokenization_method: nil
           }
         ],
         has_more: false,
         object: "list",
         total_count: 1,
         url: "/v1/customers/cus_CDYFyxfPuKA48s/sources"
       },
       subscriptions: %Stripe.List{
         data: [],
         has_more: false,
         object: "list",
         total_count: 0,
         url: "/v1/customers/cus_CDYFyxfPuKA48s/subscriptions"
       }
     }}
  end
end
