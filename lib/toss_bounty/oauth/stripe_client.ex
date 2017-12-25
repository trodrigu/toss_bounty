defmodule StripeClient do
  @stripe_impl Application.fetch_env!(:toss_bounty, :stripe_strategy)
  @moduledoc """
  An OAuth2 strategy for Stripe.
  """

  defmodule Behaviour do
    @callback authorize_url!([params: List.t]) :: :ok
    @callback get_token!([params: List.t, headers: List.t]) :: :ok
    @callback client() :: :ok
  end

  def authorize_url!(params \\ []) do
    @stripe_impl.authorize_url!()
  end

  def get_token!(code) do
    @stripe_impl.get_token!(code)
  end
end
