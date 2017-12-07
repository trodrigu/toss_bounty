defmodule TossBountyWeb.MessageThreadView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:board_id, :title, :active, :inserted_at, :updated_at]


end
