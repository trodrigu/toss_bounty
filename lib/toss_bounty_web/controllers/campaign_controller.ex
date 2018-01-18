defmodule TossBountyWeb.CampaignController do
  use TossBountyWeb.Web, :controller

  alias TossBounty.Campaigns
  alias TossBounty.Campaigns.Campaign
  alias JaSerializer.Params

  action_fallback TossBountyWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    campaigns =
      Campaigns.list_campaigns(%{ "user_id" => user_id })
    render(conn, "index.json-api", data: campaigns)
  end

  def index(conn, _params) do
    campaigns =
      Campaigns.list_campaigns()
    render(conn, "index.json-api", data: campaigns)
  end

  def create(conn, %{"data" => data = %{"type" => "campaign", "attributes" => campaign_params}}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Campaign{} = campaign} <- Campaigns.create_campaign(attrs) do
      preloaded_campaign = Repo.preload(campaign, :github_repo)

      conn
      |> put_status(:created)
      |> put_resp_header("location", campaign_path(conn, :show, preloaded_campaign))
      |> render("show.json-api", data: preloaded_campaign)
    end
  end

  def show(conn, %{"id" => id}) do
    campaign = Campaigns.get_campaign!(id)
    render(conn, "show.json-api", data: campaign)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "campaign", "attributes" => campaign_params}}) do
    campaign = Campaigns.get_campaign!(id)
    attrs = Params.to_attributes(data)

    with {:ok, %Campaign{} = campaign} <- Campaigns.update_campaign(campaign, attrs) do
      preloaded_campaign = Repo.preload(campaign, :github_repo)
      render(conn, "show.json-api", data: preloaded_campaign)
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign = Campaigns.get_campaign!(id)
    with {:ok, %Campaign{}} <- Campaigns.delete_campaign(campaign) do
      send_resp(conn, :no_content, "")
    end
  end
end
