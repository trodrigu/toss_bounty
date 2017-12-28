defmodule TossBountyWeb.RewardController do
  use TossBountyWeb.Web, :controller

  alias TossBounty.Incentive
  alias TossBounty.Incentive.Reward
  alias JaSerializer.Params

  action_fallback TossBountyWeb.FallbackController

  def index(conn, _params) do
    rewards = Incentive.list_rewards()
    render(conn, "index.json-api", rewards: rewards)
  end

  def create(conn, %{"data" => data = %{"type" => "reward", "attributes" => reward_params}}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Reward{} = reward} <- Incentive.create_reward(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", reward_path(conn, :show, reward))
      |> render("show.json-api", reward: reward)
    end
  end

  def show(conn, %{"id" => id}) do
    reward = Incentive.get_reward!(id)
    render(conn, "show.json-api", reward: reward)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "reward", "attributes" => reward_params}}) do
    reward = Incentive.get_reward!(id)
    attrs = Params.to_attributes(data)

    with {:ok, %Reward{} = reward} <- Incentive.update_reward(reward, reward_params) do
      render(conn, "show.json-api", reward: reward)
    end
  end

  def delete(conn, %{"id" => id}) do
    reward = Incentive.get_reward!(id)
    with {:ok, %Reward{}} <- Incentive.delete_reward(reward) do
      send_resp(conn, :no_content, "")
    end
  end
end
