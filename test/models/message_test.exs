defmodule TossBounty.MessageTest do
  use TossBounty.ModelCase

  alias TossBounty.Message

  @valid_attrs %{message_thread_id: 42, text: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
