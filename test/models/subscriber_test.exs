defmodule TossBounty.SubscriberTest do
  use TossBounty.ModelCase

  alias TossBounty.Subscriber

  @valid_attrs %{active: true, message_thread_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Subscriber.changeset(%Subscriber{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Subscriber.changeset(%Subscriber{}, @invalid_attrs)
    refute changeset.valid?
  end
end
