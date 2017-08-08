defmodule TossBounty.AgreementSignerTest do
  use TossBounty.ModelCase

  alias TossBounty.AgreementSigner

  @valid_attrs %{agreement_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AgreementSigner.changeset(%AgreementSigner{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AgreementSigner.changeset(%AgreementSigner{}, @invalid_attrs)
    refute changeset.valid?
  end
end
