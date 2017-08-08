defmodule TossBounty.SkillView do
  use TossBounty.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]


end
