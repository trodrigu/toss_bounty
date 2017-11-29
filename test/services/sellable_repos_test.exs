defmodule TossBounty.SellableReposTest do
  use TossBounty.ModelCase
  alias TossBounty.SellableRepos
  alias TossBounty.User
  alias TossBounty.SellableRepos.MockReposGrabber


  describe "call/2" do

    test "when there are zero repos with issues" do
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      SellableRepos.MockReposGrabber.clear
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "Barter", "open_issues_count" => 0 })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 0
    end

    test "when there is one repo with more than zero issues" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "open_issues_count" => 3 })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 1
      assert ["toss_bounty"] == result
    end

    test "when there are ten repos with more than zero issues" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      repos =
        [
          %{ "name" => "awesome_repo_1", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_2", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_3", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_4", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_5", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_6", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_7", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_8", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_9", "open_issues_count" => 3 },
          %{ "name" => "awesome_repo_10", "open_issues_count" => 3 },
        ]
      SellableRepos.MockReposGrabber.insert_repos repos
      result = SellableRepos.call(user)
      assert Enum.count(result) == 10
      assert ["awesome_repo_1",
              "awesome_repo_2",
              "awesome_repo_3",
              "awesome_repo_4",
              "awesome_repo_5",
              "awesome_repo_6",
              "awesome_repo_7",
              "awesome_repo_8",
              "awesome_repo_9",
              "awesome_repo_10"] == result
    end
  end
end
