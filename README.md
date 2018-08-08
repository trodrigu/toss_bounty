# TossBounty Backend
[TossBounty at toss_bounty](https://tossbounty.com/#/contribute/1)

# Getting Started
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`

# 3rd Party Dependencies

  * create a Github oauth [app](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) and grab the client id, client secret and redirect uri
  * create a Stripe [account](https://dashboard.stripe.com/register) and grab the secret key and connect client id
  * create a Mailgun [account](https://signup.mailgun.com/new/signup) and grab the api key and domain

# Development Configuration

  * create a .env at the base of the project with following (note the front end url)

```
export GITHUB_CLIENT_ID=
export GITHUB_CLIENT_SECRET=
export GITHUB_REDIRECT_URI=
export FRONT_END_URL=http://localhost:8000
export STRIPE_SECRET_KEY=
export STRIPE_PLATFORM_CLIENT_ID=
export STRIPE_CONNECT_CLIENT_ID=
export MAILGUN_API_KEY=
export MAILGUN_DOMAIN=
```

# Running the development server
  * read the env vars into the environment with `source .env`
  * start the backend with `mix phx.server`