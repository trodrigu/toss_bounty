defmodule TossBounty.Repo do
  use Ecto.Repo, otp_app: :toss_bounty
  use Scrivener, page_size: 10
end
