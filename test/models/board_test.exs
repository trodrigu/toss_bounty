defmodule TossBounty.BoardTest do
  use TossBounty.ModelCase

  alias TossBounty.Board

  @valid_attrs %{latitude: "120.5", longitude: "120.5", needed_by: %{day: 17, month: 4, year: 2010}, skill_needed: 42, skill_offered: 42, status: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Board.changeset(%Board{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Board.changeset(%Board{}, @invalid_attrs)
    refute changeset.valid?
  end
end
