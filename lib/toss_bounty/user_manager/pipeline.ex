defmodule TossBounty.UserManager.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :toss_bounty,
    error_handler: TossBounty.UserManager.ErrorHandler,
    module: TossBounty.UserManager.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  # Load the user if either of the verifications worked
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
