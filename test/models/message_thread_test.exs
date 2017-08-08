defmodule TossBounty.MessageThreadTest do
  use TossBounty.ModelCase

  alias TossBounty.MessageThread

  @valid_attrs %{active: true, board_id: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MessageThread.changeset(%MessageThread{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MessageThread.changeset(%MessageThread{}, @invalid_attrs)
    refute changeset.valid?
  end
end
