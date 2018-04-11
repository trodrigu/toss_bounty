defmodule TossBountyWeb.CampaignController do
  use TossBountyWeb.Web, :controller

  alias TossBounty.Campaigns
  alias TossBounty.Campaigns.Campaign
  alias TossBounty.Accounts.CurrentUser
  alias JaSerializer.Params
  require Ecto.Query

  action_fallback(TossBountyWeb.FallbackController)

  def index(conn, params = %{"user_id" => user_id, "page" => page, "page_size" => page_size}) do
    page =
      TossBounty.Campaigns.Campaign
      |> Ecto.Query.where(user_id: ^user_id)
      |> Repo.paginate(params)

    entries =
      page.entries
      |> Repo.preload(:github_repo)
      |> Repo.preload(:user)

    meta_data = %{
      "page_number" => page.page_number,
      "page_size" => page.page_size,
      "total_pages" => page.total_pages,
      "total_entries" => page.total_entries
    }

    render(conn, "index.json-api", data: entries, opts: [meta: meta_data])
  end

  def index(conn, _params) do
    campaigns = Campaigns.list_campaigns()

    render(conn, "index.json-api", data: campaigns)
  end

  def create(conn, %{"data" => data = %{"type" => "campaign", "attributes" => campaign_params}}) do
    attrs = Params.to_attributes(data)

    with {:ok, %Campaign{} = campaign} <- Campaigns.create_campaign(attrs) do
      preloaded_campaign = Repo.preload(campaign, [:github_repo, :user])

      conn
      |> put_status(:created)
      |> put_resp_header("location", campaign_path(conn, :show, preloaded_campaign))
      |> render("show.json-api", data: preloaded_campaign)
    end
  end

  def show(conn, %{"id" => id}) do
    campaign =
      Campaigns.get_campaign!(id)
      |> Repo.preload([:github_repo, :user])

    render(conn, "show.json-api", data: campaign)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "campaign", "attributes" => campaign_params}
      }) do
    campaign =
      Campaigns.get_campaign!(id)
      |> Repo.preload([:github_repo, :user])

    attrs = Params.to_attributes(data)

    current_user = conn.assigns[:current_user]

    case TossBounty.Policy.authorize(current_user, :administer, campaign, attrs) do
      {:ok, :authorized} ->
        with {:ok, %Campaign{} = campaign} <- Campaigns.update_campaign(campaign, attrs) do
          preloaded_campaign = Repo.preload(campaign, :github_repo)
          render(conn, "show.json-api", data: preloaded_campaign)
        end

      {:error, :not_authorized} ->
        message =
          "User with id: #{current_user.id} is not authorized " <>
            "to administer campaign with id: #{campaign.id}"

        conn
        |> put_status(403)
        |> render("403.json-api", %{message: message})
    end
  end

  def delete(conn, %{"id" => id}) do
    campaign = Campaigns.get_campaign!(id)

    current_user = conn.assigns[:current_user]

    case TossBounty.Policy.authorize(current_user, :administer, campaign) do
      {:ok, :authorized} ->
        with {:ok, %Campaign{}} <- Campaigns.delete_campaign(campaign) do
          send_resp(conn, :no_content, "")
        end

      {:error, :not_authorized} ->
        message =
          "User with id: #{current_user.id} is not authorized " <>
            "to administer campaign with id: #{campaign.id}"

        conn
        |> put_status(403)
        |> render("403.json-api", %{message: message})
    end
  end
end
