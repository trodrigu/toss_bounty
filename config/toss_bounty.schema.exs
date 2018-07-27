@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "mime.types": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for mime.types here.",
      hidden: false,
      to: "mime.types"
    ],
    "logger.console.metadata": [
      commented: false,
      datatype: [
        list: :atom
      ],
      default: [
        :request_id
      ],
      doc: "Provide documentation for logger.console.metadata here.",
      hidden: false,
      to: "logger.console.metadata"
    ],
    "logger.console.format": [
      commented: false,
      datatype: :binary,
      default: """
      [$level] $message
      """,
      doc: "Provide documentation for logger.console.format here.",
      hidden: false,
      to: "logger.console.format"
    ],
    "phoenix.format_encoders.json-api": [
      commented: false,
      datatype: :atom,
      default: Poison,
      doc: "Provide documentation for phoenix.format_encoders.json-api here.",
      hidden: false,
      to: "phoenix.format_encoders.json-api"
    ],
    "phoenix.stacktrace_depth": [
      commented: false,
      datatype: :integer,
      default: 20,
      doc: "Provide documentation for phoenix.stacktrace_depth here.",
      hidden: false,
      to: "phoenix.stacktrace_depth"
    ],
    "oauth2.Elixir.Github.client_id": [
      commented: false,
      datatype: :binary,
      default: "58c8cf9ec191b7405b9b",
      doc: "Provide documentation for oauth2.Elixir.Github.client_id here.",
      hidden: false,
      to: "oauth2.Elixir.Github.client_id"
    ],
    "oauth2.Elixir.Github.client_secret": [
      commented: false,
      datatype: :binary,
      default: "f0d48b14781a8853f9afc22729faf9a868b9a860",
      doc: "Provide documentation for oauth2.Elixir.Github.client_secret here.",
      hidden: false,
      to: "oauth2.Elixir.Github.client_secret"
    ],
    "oauth2.Elixir.Github.redirect_uri": [
      commented: false,
      datatype: :binary,
      default: "http://localhost:4000/auth/github/callback",
      doc: "Provide documentation for oauth2.Elixir.Github.redirect_uri here.",
      hidden: false,
      to: "oauth2.Elixir.Github.redirect_uri"
    ],
    "stripity_stripe.api_key": [
      commented: false,
      datatype: :binary,
      default: "sk_test_3HJrJrLhOPzdk5TUuPUxTe6p",
      doc: "Provide documentation for stripity_stripe.api_key here.",
      hidden: false,
      to: "stripity_stripe.api_key"
    ],
    "stripity_stripe.connect_client_id": [
      commented: false,
      datatype: :binary,
      default: "ca_C0C3t2jD3OD6ztNxxW7zFgSVKNlYOhn9",
      doc: "Provide documentation for stripity_stripe.connect_client_id here.",
      hidden: false,
      to: "stripity_stripe.connect_client_id"
    ],
    "toss_bounty.ecto_repos": [
      commented: false,
      datatype: [
        list: :atom
      ],
      default: [
        TossBounty.Repo
      ],
      doc: "Provide documentation for toss_bounty.ecto_repos here.",
      hidden: false,
      to: "toss_bounty.ecto_repos"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base": [
      commented: false,
      datatype: :binary,
      default: "MAjVtcm9+3sgx0N/rAUPlgtkkZ1fC8X5lWUaCrXFl9GxDz0HOlr3yKhoZ+DWggzz",
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.view": [
      commented: false,
      datatype: :atom,
      default: TossBountyWeb.ErrorView,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.view here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.view"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.accepts": [
      commented: false,
      datatype: [
        list: :binary
      ],
      default: [
        "html",
        "json",
        "json-api"
      ],
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.accepts here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.accepts"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.name": [
      commented: false,
      datatype: :atom,
      default: TossBounty.PubSub,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.name here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.name"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.adapter": [
      commented: false,
      datatype: :atom,
      default: Phoenix.PubSub.PG2,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.adapter here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.adapter"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port": [
      commented: false,
      datatype: :integer,
      default: 4000,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.debug_errors": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.debug_errors here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.debug_errors"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.code_reloader": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.code_reloader here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.code_reloader"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.check_origin": [
      commented: false,
      datatype: :atom,
      default: false,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.check_origin here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.check_origin"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.live_reload.patterns": [
      commented: false,
      datatype: [
        list: :binary
      ],
      default: [
        ~r/priv\/static\/.*(js|css|png|jpeg|jpg|gif|svg)$/,
        ~r/priv\/gettext\/.*(po)$/,
        ~r/lib\/toss_bounty\/views\/.*(ex)$/,
        ~r/lib\/toss_bounty\/templates\/.*(eex)$/
      ],
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.live_reload.patterns here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.live_reload.patterns"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.adapter": [
      commented: false,
      datatype: :atom,
      default: Ecto.Adapters.Postgres,
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.adapter here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.adapter"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.username": [
      commented: false,
      datatype: :binary,
      default: "postgres",
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.username here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.username"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.database": [
      commented: false,
      datatype: :binary,
      default: "toss_bounty_dev",
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.database here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.database"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.hostname": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.hostname here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.hostname"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.pool_size": [
      commented: false,
      datatype: :integer,
      default: 10,
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.pool_size here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.pool_size"
    ],
    "toss_bounty.repo_grabber": [
      commented: false,
      datatype: :atom,
      default: TossBounty.Github.SellableRepos.TentacatReposGrabber,
      doc: "Provide documentation for toss_bounty.repo_grabber here.",
      hidden: false,
      to: "toss_bounty.repo_grabber"
    ],
    "toss_bounty.issue_grabber": [
      commented: false,
      datatype: :atom,
      default: TossBounty.Github.SellableIssues.TentacatIssuesGrabber,
      doc: "Provide documentation for toss_bounty.issue_grabber here.",
      hidden: false,
      to: "toss_bounty.issue_grabber"
    ],
    "toss_bounty.github_strategy": [
      commented: false,
      datatype: :atom,
      default: TossBountyWeb.GithubStrategy,
      doc: "Provide documentation for toss_bounty.github_strategy here.",
      hidden: false,
      to: "toss_bounty.github_strategy"
    ],
    "toss_bounty.customer_creator": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripeCustomerCreator,
      doc: "Provide documentation for toss_bounty.customer_creator here.",
      hidden: false,
      to: "toss_bounty.customer_creator"
    ],
    "toss_bounty.plan_creator": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripePlanCreator,
      doc: "Provide documentation for toss_bounty.plan_creator here.",
      hidden: false,
      to: "toss_bounty.plan_creator"
    ],
    "toss_bounty.plan_deleter": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripePlanDeleter,
      doc: "Provide documentation for toss_bounty.plan_deleter here.",
      hidden: false,
      to: "toss_bounty.plan_deleter"
    ],
    "toss_bounty.plan_updater": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripePlanUpdater,
      doc: "Provide documentation for toss_bounty.plan_updater here.",
      hidden: false,
      to: "toss_bounty.plan_updater"
    ],
    "toss_bounty.subscription_creator": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripeSubscriptionCreator,
      doc: "Provide documentation for toss_bounty.subscription_creator here.",
      hidden: false,
      to: "toss_bounty.subscription_creator"
    ],
    "toss_bounty.subscription_deleter": [
      commented: false,
      datatype: :atom,
      default: TossBounty.StripeProcessing.StripeSubscriptionDeleter,
      doc: "Provide documentation for toss_bounty.subscription_deleter here.",
      hidden: false,
      to: "toss_bounty.subscription_deleter"
    ],
    "toss_bounty.front_end_url": [
      commented: false,
      datatype: :binary,
      default: "http://localhost:8000",
      doc: "Provide documentation for toss_bounty.front_end_url here.",
      hidden: false,
      to: "toss_bounty.front_end_url"
    ],
    "toss_bounty.stripe_strategy": [
      commented: false,
      datatype: :atom,
      default: TossBountyWeb.StripeClientStrategy,
      doc: "Provide documentation for toss_bounty.stripe_strategy here.",
      hidden: false,
      to: "toss_bounty.stripe_strategy"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Mailer.adapter": [
      commented: false,
      datatype: :atom,
      default: Bamboo.LocalAdapter,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Mailer.adapter here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Mailer.adapter"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Mailer.api_key": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Mailer.api_key here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Mailer.api_key"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Mailer.domain": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Mailer.domain here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Mailer.domain"
    ],
    "ja_resource.repo": [
      commented: false,
      datatype: :atom,
      default: TossBounty.Repo,
      doc: "Provide documentation for ja_resource.repo here.",
      hidden: false,
      to: "ja_resource.repo"
    ],
    "guardian.Elixir.Guardian.issuer": [
      commented: false,
      datatype: :binary,
      default: "TossBounty",
      doc: "Provide documentation for guardian.Elixir.Guardian.issuer here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.issuer"
    ],
    "guardian.Elixir.Guardian.ttl": [
      commented: false,
      datatype: {:integer, :atom},
      default: {30, :days},
      doc: "Provide documentation for guardian.Elixir.Guardian.ttl here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.ttl"
    ],
    "guardian.Elixir.Guardian.secret_key": [
      commented: false,
      datatype: :binary,
      default: "duIaK6Gn5QX0PSDK4j+IM3Ll02JwbNRN66N+5Iihnop7iPKj8VUpQVGmqojVeXmo",
      doc: "Provide documentation for guardian.Elixir.Guardian.secret_key here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.secret_key"
    ],
    "guardian.Elixir.Guardian.serializer": [
      commented: false,
      datatype: :atom,
      default: TossBounty.GuardianSerializer,
      doc: "Provide documentation for guardian.Elixir.Guardian.serializer here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.serializer"
    ],
    "tentacat.extra_headers": [
      commented: false,
      datatype: [
        list: {:binary, :binary}
      ],
      default: [
        {"Accept", "application/vnd.github.squirrel-girl-preview"}
      ],
      doc: "Provide documentation for tentacat.extra_headers here.",
      hidden: false,
      to: "tentacat.extra_headers"
    ]
  ],
  transforms: [],
  validators: []
]
