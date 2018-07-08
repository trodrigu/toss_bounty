defmodule TossBountyWeb.Email do
  import Bamboo.Email

  def welcome_email(user) do
    new_email()
    |> to(user.email)
    |> from("tommy@tossbounty.com")
    |> subject("Welcome!!!")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
  end
end
