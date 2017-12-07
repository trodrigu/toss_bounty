defmodule TossBountyWeb.AgreementView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:board_id, :details, :inserted_at, :updated_at]


end
