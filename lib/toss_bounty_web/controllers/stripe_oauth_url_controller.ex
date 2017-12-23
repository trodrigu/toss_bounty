defmodule TossBountyWeb.StripeOauthUrlController do
  use TossBountyWeb.Web, :controller

  def show(conn, _params) do
    url = Stripe.Connect.OAuth.authorize_url
    render conn, "show.json", %{ url: url }
  end
end
