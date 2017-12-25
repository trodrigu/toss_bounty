defmodule TossBountyWeb.MockStripeClientStrategy do
  @behaviour TossBountyWeb.StripeClient.Behaviour
  defmodule TokenResponse do
    defstruct [
      :access_token,
      :livemode,
      :refresh_token,
      :scope,
      :stripe_user_id,
      :stripe_publishable_key,
      :token_type
    ]
  end

  def get_token!(_code) do
    Map.put(%TokenResponse{}, :access_token, "some-token")
  end
end
