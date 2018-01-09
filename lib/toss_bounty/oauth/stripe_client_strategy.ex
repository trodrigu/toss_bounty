defmodule TossBountyWeb.StripeClientStrategy do
  @behaviour TossBountyWeb.StripeClient

  def get_token!(code, params \\ []) do
    {:ok, resp} = Stripe.Connect.OAuth.token(code[:code])
    resp
  end

  def authorize_url! do
    Stripe.Connect.OAuth.authorize_url
  end
end
