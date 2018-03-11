defmodule TossBountyWeb.CustomerControllerTest do
  use TossBountyWeb.ApiCase, resource_name: :customer
  alias TossBounty.StripeProcessing.Customer
  alias TossBounty.StripeProcessing
  alias TossBounty.Repo
  alias TossBounty.Accounts.User
  alias TossBounty.Campaigns.Campaign
  alias TossBounty.Campaigns
  alias TossBounty.Github.GithubRepo

  defp dasherize_keys(attrs) do
    Enum.map(attrs, fn {k, v} -> {JaSerializer.Formatter.Utils.format_key(k), v} end)
    |> Enum.into(%{})
  end

  def create_fixture_token(attrs \\ %{}) do
    user = attrs[:user]

    token_attrs = %{
      uuid: "some-token-1",
      user_id: user.id
    }

    {:ok, token} = StripeProcessing.create_token(token_attrs)

    {:ok, user: user, token: token}
  end

  def create_fixture_github_repo(attrs \\ %{}) do
    user = attrs[:user]

    github_repo_attrs = %{
      name: "a name",
      owner: "an owner",
      bountiful_score: 5,
      image: "an-img-path",
      user_id: user.id
    }

    {:ok, github_repo} =
      %GithubRepo{}
      |> GithubRepo.changeset(github_repo_attrs)
      |> Repo.insert()

    {:ok, user: user, github_repo: github_repo}
  end

  def create_fixture_campaign(attrs \\ %{}) do
    user = attrs[:user]

    github_repo = attrs[:github_repo]

    campaign_attrs = %{
      current_funding: 100.0,
      funding_end_date: Timex.parse!("Tue, 06 Mar 2013 01:25:19 +0200", "{RFC1123}"),
      funding_goal: 456.7,
      long_description: "some updated long_description",
      user_id: user.id,
      github_repo_id: github_repo.id
    }

    {:ok, campaign} = Campaigns.create_campaign(campaign_attrs)

    {:ok, user: user, campaign: campaign}
  end

  defp relationships(attrs \\ %{}) do
    token = attrs[:token]
    campaign = attrs[:campaign]

    %{
      "campaign" => %{
        "data" => %{
          "type" => "campaign",
          "id" => campaign.id
        }
      },
      "token" => %{
        "data" => %{
          "type" => "token",
          "id" => token.id
        }
      }
    }
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user = Repo.insert!(%User{})
    {:ok, conn: conn, user: user}
  end

  setup [:create_fixture_token, :create_fixture_github_repo, :create_fixture_campaign]

  describe "create customer" do
    @tag :authenticated
    test "renders customer when data is valid", %{
      conn: conn,
      token: token,
      campaign: campaign
    } do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer",
            "relationships" => relationships(%{token: token, campaign: campaign})
          }
        })

      data = json_response(conn, 201)["data"]
      assert %{"id" => id} = data
      assert data["relationships"]["campaign"]["data"]["id"] == "#{campaign.id}"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer"
          }
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when not authenticated", %{conn: conn, token: token, campaign: campaign} do
      conn =
        post(conn, customer_path(conn, :create), %{
          "meta" => %{},
          "data" => %{
            "type" => "customer",
            "relationships" => relationships(%{token: token, campaign: campaign})
          }
        })

      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
