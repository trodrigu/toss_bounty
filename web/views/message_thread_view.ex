defmodule TossBounty.MessageThreadView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:board_id, :title, :active, :inserted_at, :updated_at]


end
