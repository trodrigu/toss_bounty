defmodule TossBountyWeb.SkillView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]


end
