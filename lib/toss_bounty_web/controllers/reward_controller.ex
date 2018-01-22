defmodule TossBountyWeb.RewardController do
  use TossBountyWeb.Web, :controller

  alias TossBounty.Incentive
  alias TossBounty.Incentive.Reward
  alias JaSerializer.Params

  action_fallback TossBountyWeb.FallbackController

  def index(conn, %{"campaign_id" => campaign_id}) do
    rewards = Incentive.list_rewards(%{"campaign_id" => campaign_id})
    render(conn, "index.json-api", rewards: rewards)
  end

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

    current_user =
      conn.assigns[:current_user]

    case TossBounty.Policy.authorize(current_user, :administer, reward, attrs) do
      {:ok, :authorized} ->
        with {:ok, %Reward{} = reward} <- Incentive.update_reward(reward, reward_params) do
          render(conn, "show.json-api", reward: reward)
        end

      {:error, :not_authorized} ->
        message =
          "User with id: #{current_user.id} is not authorized " <>
          "to administer reward with id: #{reward.id}"

        conn
        |> put_status(403)
        |> render("403.json-api", %{message: message})
    end
  end

  def delete(conn, %{"id" => id}) do
    reward = Incentive.get_reward!(id)

    current_user =
      conn.assigns[:current_user]

    case TossBounty.Policy.authorize(current_user, :administer, reward) do
      {:ok, :authorized} ->
        with {:ok, %Reward{}} <- Incentive.delete_reward(reward) do
          send_resp(conn, :no_content, "")
        end

      {:error, :not_authorized} ->
        message =
          "User with id: #{current_user.id} is not authorized " <>
          "to administer reward with id: #{reward.id}"

        conn
        |> put_status(403)
        |> render("403.json-api", %{message: message})
    end
  end
end
