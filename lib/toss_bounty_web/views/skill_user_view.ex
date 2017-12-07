defmodule TossBountyWeb.SkillUserView do
  use TossBountyWeb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:user_id, :skill_id, :details, :inserted_at, :updated_at]


end
