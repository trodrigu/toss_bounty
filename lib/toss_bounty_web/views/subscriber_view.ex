defmodule TossBountyWeb.SubscriberView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:user_id, :message_thread_id, :active, :inserted_at, :updated_at]


end
