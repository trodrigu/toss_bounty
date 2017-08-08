defmodule TossBounty.ContactInfoView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:full_name, :phone, :website, :inserted_at, :updated_at]


end
