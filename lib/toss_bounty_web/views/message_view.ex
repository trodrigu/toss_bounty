defmodule TossBountyWeb.MessageView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:user_id, :message_thread_id, :text, :inserted_at, :updated_at]


end
