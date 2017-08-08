defmodule TossBounty.AgreementTest do
  use TossBounty.ModelCase

  alias TossBounty.Agreement

  @valid_attrs %{board_id: 42, details: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Agreement.changeset(%Agreement{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Agreement.changeset(%Agreement{}, @invalid_attrs)
    refute changeset.valid?
  end
end
