defmodule TossBounty.IncentiveTest do
  use TossBountyWeb.DataCase

  alias TossBounty.Incentive

  describe "rewards" do
    alias TossBounty.Incentive.Reward

    @valid_attrs %{
      description: "some description",
      donation_level: 120.5,
    }
    @update_attrs %{
      description: "some updated description",
      donation_level: 456.7,
    }
    @invalid_attrs %{
      description: nil,
      donation_level: nil,
    }

    def reward_fixture(attrs \\ %{}) do
      {:ok, reward} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Incentive.create_reward()

      reward
    end

    test "list_rewards/0 returns all rewards" do
      reward = reward_fixture()
      assert Incentive.list_rewards() == [reward]
    end

    test "get_reward!/1 returns the reward with given id" do
      reward = reward_fixture()
      assert Incentive.get_reward!(reward.id) == reward
    end

    test "create_reward/1 with valid data creates a reward" do
      assert {:ok, %Reward{} = reward} = Incentive.create_reward(@valid_attrs)
      assert reward.description == "some description"
      assert reward.donation_level == 120.5
    end

    test "create_reward/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Incentive.create_reward(@invalid_attrs)
    end

    test "update_reward/2 with valid data updates the reward" do
      reward = reward_fixture()
      assert {:ok, reward} = Incentive.update_reward(reward, @update_attrs)
      assert %Reward{} = reward
      assert reward.description == "some updated description"
      assert reward.donation_level == 456.7
    end

    test "update_reward/2 with invalid data returns error changeset" do
      reward = reward_fixture()
      assert {:error, %Ecto.Changeset{}} = Incentive.update_reward(reward, @invalid_attrs)
      assert reward == Incentive.get_reward!(reward.id)
    end

    test "delete_reward/1 deletes the reward" do
      reward = reward_fixture()
      assert {:ok, %Reward{}} = Incentive.delete_reward(reward)
      assert_raise Ecto.NoResultsError, fn -> Incentive.get_reward!(reward.id) end
    end

    test "change_reward/1 returns a reward changeset" do
      reward = reward_fixture()
      assert %Ecto.Changeset{} = Incentive.change_reward(reward)
    end
  end
end
