defmodule TossBountyWeb.RewardView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView
  attributes [:description, :donation_level]

  # def render("index.json-api", %{rewards: rewards}) do
  #   %{data: render_many(rewards, RewardView, "reward.json")}
  # end

  # def render("show.json-api", %{reward: reward}) do
  #   %{data: render_one(reward, RewardView, "reward.json")}
  # end

  # def render("reward.json-api", %{reward: reward}) do
  #   %{id: reward.id,
  #     description: reward.description,
  #     donation_level: reward.donation_level}
  # end
  def render("403.json-api", %{message: message}) do
    %{
      errors: [
        %{
          id: "FORBIDDEN",
          title: "403 Forbidden",
          detail: message,
          status: 403,
        }
      ]
    }
  end
end
