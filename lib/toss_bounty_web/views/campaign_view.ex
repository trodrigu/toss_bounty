defmodule TossBountyWeb.CampaignView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes([
    :current_funding,
    :funding_goal,
    :long_description,
    :inserted_at,
    :updated_at
  ])

  has_one(
    :user,
    include: true,
    serializer: TossBountyWeb.MaintainerUserView,
    type: "user"
  )

  has_one(
    :github_repo,
    include: true,
    serializer: TossBountyWeb.GithubRepoView,
    type: "github_repo"
  )

  def render("403.json-api", %{message: message}) do
    %{
      errors: [
        %{
          id: "FORBIDDEN",
          title: "403 Forbidden",
          detail: message,
          status: 403
        }
      ]
    }
  end
end
