defmodule TossBounty.SubscriberView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:user_id, :message_thread_id, :active, :inserted_at, :updated_at]


end
