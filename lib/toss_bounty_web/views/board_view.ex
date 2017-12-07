defmodule TossBountyWeb.BoardView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:user_id, :skill_needed, :skill_offered, :status, :needed_by, :longitude, :latitude, :inserted_at, :updated_at]


end
