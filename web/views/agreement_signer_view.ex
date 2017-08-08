defmodule TossBounty.AgreementSignerView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:agreement_id, :user_id, :inserted_at, :updated_at]


end
