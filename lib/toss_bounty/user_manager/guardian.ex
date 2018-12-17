defmodule TossBounty.UserManager.Guardian do
  use Guardian, otp_app: :toss_bounty
  alias TossBounty.Repo
  alias TossBounty.Accounts.User
  alias TossBounty.UserManager

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => id}) do
    case UserManager.get_user!(id) do
      nil -> {:error, "Unknown resource type"}
      user -> {:ok, user}
    end
  end
end
