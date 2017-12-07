defmodule TossBountyWeb.AgreementSignerView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:agreement_id, :user_id, :inserted_at, :updated_at]


end
