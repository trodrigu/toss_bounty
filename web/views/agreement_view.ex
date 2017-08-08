defmodule TossBounty.AgreementView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:board_id, :details, :inserted_at, :updated_at]


end
