defmodule TossBounty.AddressView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:street_address, :street_address_2, :city, :state, :zip, :user_id, :latitude, :longitude, :inserted_at, :updated_at]


end
