defmodule TossBountyWeb.SellableReposTest do
  use TossBountyWeb.ModelCase
  alias TossBountyWeb.SellableRepos
  alias TossBountyWeb.User
  alias TossBountyWeb.SellableRepos.MockReposGrabber


  describe "call/2" do

    test "when there are zero repos with stargazers" do
      user = with {:ok, user} <- Repo.insert!(%User{email: "trodriguez91@icloud.com"}), do: user
      SellableRepos.MockReposGrabber.clear
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "Barter", "stargazers_count" => 0, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 0
    end

    test "when there is one repo with more than zero stargazers" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert Enum.count(result) == 1
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 }] == result
    end

    test "when there are ten repos with more than zero stargazers" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      repos =
        [
          %{ "name" => "awesome_repo_1", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_2", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_3", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_4", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_5", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_6", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_7", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_8", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_9", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
          %{ "name" => "awesome_repo_10", "stargazers_count" => 3, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } },
        ]
      SellableRepos.MockReposGrabber.insert_repos repos
      result = SellableRepos.call(user)
      assert Enum.count(result) == 10
      assert [
        %{ name: "awesome_repo_1", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_2", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_3", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_4", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_5", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_6", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_7", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_8", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_9", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 },
        %{ name: "awesome_repo_10", owner: "smcfarlane", image: "avatar-source", bountiful_score: 0 }
      ] == result
    end

    test "when there is one repo with between 20 to 40 stargazers returns score of 1" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 21, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 1 }] == result
    end

    test "when there is one repo with between 40 to 60 stargazers returns score of 2" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 41, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 2 }] == result
    end

    test "when there is one repo with between 60 to 80 stargazers returns score of 3" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 61, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 3 }] == result
    end

    test "when there is one repo with between 80 to 100 stargazers returns score of 4" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 81, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 4 }] == result
    end

    test "when there is one repo with over 100 stargazers returns score of 5" do
      SellableRepos.MockReposGrabber.clear
      user = with {:ok, user} <- Repo.insert!(%User{email: "test@example.com"}), do: user
      SellableRepos.MockReposGrabber.insert_repo(%{ "name" => "toss_bounty", "stargazers_count" => 101, "owner" => %{ "login" => "smcfarlane", "avatar_url" => "avatar-source" } })
      result = SellableRepos.call(user)
      assert [%{ name: "toss_bounty", owner: "smcfarlane", image: "avatar-source", bountiful_score: 5 }] == result
    end
  end
end
