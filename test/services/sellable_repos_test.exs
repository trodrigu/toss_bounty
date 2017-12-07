defmodule TossBountyWeb.SellableReposTest do
  use TossBountyWeb.ModelCase
  alias TossBountyWeb.SellableRepos
  alias TossBountyWeb.User
  alias TossBountyWeb.SellableRepos.MockReposGrabber


  describe "call/2" do

    test "when there are zero repos with issues" do
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      SellableRepos.MockReposGrabber.clear
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "Barter", "open_issues_count" => 0, "owner" => %{ "login" => "smcfarlane" } })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 0
    end

    test "when there is one repo with more than zero issues" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 1
      assert [%{ name: "toss_bounty", owner: "smcfarlane" }] == result
    end

    test "when there are ten repos with more than zero issues" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      repos =
        [
          %{ "name" => "awesome_repo_1", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_2", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_3", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_4", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_5", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_6", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_7", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_8", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_9", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
          %{ "name" => "awesome_repo_10", "open_issues_count" => 3, "owner" => %{ "login" => "smcfarlane" } },
        ]
      SellableRepos.MockReposGrabber.insert_repos repos
      result = SellableRepos.call(user)
      assert Enum.count(result) == 10
      assert [
        %{ name: "awesome_repo_1", owner: "smcfarlane" },
        %{ name: "awesome_repo_2", owner: "smcfarlane" },
        %{ name: "awesome_repo_3", owner: "smcfarlane" },
        %{ name: "awesome_repo_4", owner: "smcfarlane" },
        %{ name: "awesome_repo_5", owner: "smcfarlane" },
        %{ name: "awesome_repo_6", owner: "smcfarlane" },
        %{ name: "awesome_repo_7", owner: "smcfarlane" },
        %{ name: "awesome_repo_8", owner: "smcfarlane" },
        %{ name: "awesome_repo_9", owner: "smcfarlane" },
        %{ name: "awesome_repo_10", owner: "smcfarlane" }
      ] == result
    end
  end
end
