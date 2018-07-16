defmodule TossBountyWeb.Email do
  import Bamboo.Email

  def welcome_email(user) do
    new_email()
    |> to(user.email)
    |> from("tommy@tossbounty.com")
    |> subject("Welcome to TossBounty!!!")
    |> html_body(
      """
      <span>Welcome, <strong>#{user.email}</strong>.
      Get started by adding your <a href="https://tossbounty.com/campaigns">campaigns</a>
      or discover other peoples at <a href="https://tossbounty.com/discover">discover</a>.

      <br/>
      <br/>

      Best regards,

      <br/>
      <br/>

      Tommy
      """
    )
  end
end
