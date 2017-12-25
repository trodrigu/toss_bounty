defmodule TossBountyWeb.StripeClientStrategy do
  @behaviour TossBountyWeb.StripeClient

  def get_token!(code, params \\ []) do
    {:ok, resp} = Stripe.Connect.OAuth.token(code)
    resp
  end
end
