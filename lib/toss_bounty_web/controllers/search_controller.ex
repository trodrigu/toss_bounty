defmodule TossBountyWeb.SearchController do
  use TossBountyWeb.Web, :controller

  alias TossBounty.Campaigns
  alias TossBounty.Campaigns.Campaign
  alias TossBounty.Accounts.CurrentUser
  alias JaSerializer.Params
  require Ecto.Query

  action_fallback(TossBountyWeb.FallbackController)

  def index(conn, params = %{"page" => page, "page_size" => page_size, "search" => search}) do
    IO.inspect search

    search_result =
      TossBountySearch.run(Campaign, search)

    page =
      search_result
      |> Repo.paginate(params)

    entries =
      page.entries
      |> Repo.preload(:github_repo)
      |> Repo.preload(:user)
      |> IO.inspect

    meta_data = %{
      "page_number" => page.page_number,
      "page_size" => page.page_size,
      "total_pages" => page.total_pages,
      "total_entries" => page.total_entries
    }

    render(conn, "index.json-api", data: entries, opts: [meta: meta_data])
  end
end
