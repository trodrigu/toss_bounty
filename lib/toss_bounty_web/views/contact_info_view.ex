defmodule TossBountyWeb.ContactInfoView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:full_name, :phone, :website, :inserted_at, :updated_at]


end
