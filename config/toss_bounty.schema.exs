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
    "phoenix.format_encoders.json-api": [
      commented: false,
      datatype: :atom,
      default: Poison,
      doc: "Provide documentation for phoenix.format_encoders.json-api here.",
      hidden: false,
      to: "phoenix.format_encoders.json-api"
    ],
    "mime.types": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for mime.types here.",
      hidden: false,
      to: "mime.types"
    ],
    "logger.console.format": [
      commented: false,
      datatype: :binary,
      default: """
      $time $metadata[$level] $message
      """,
      doc: "Provide documentation for logger.console.format here.",
      hidden: false,
      to: "logger.console.format"
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
    "logger.level": [
      commented: false,
      datatype: :atom,
      default: :info,
      doc: "Provide documentation for logger.level here.",
      hidden: false,
      to: "logger.level"
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
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.view": [
      commented: false,
      datatype: :atom,
      default: TossBountyWeb.ErrorView,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.view here.",
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
        "json"
      ],
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.render_errors.accepts here.",
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
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.adapter here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.pubsub.adapter"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host": [
      commented: false,
      datatype: :binary,
      default: "api.tossbounty.com",
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.host"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.port": [
      commented: false,
      datatype: {:atom, :binary},
      default: {:system, "PORT"},
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.url.port here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.url.port"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port": [
      commented: false,
      datatype: :integer,
      default: 80,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.http.port"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.port": [
      commented: false,
      datatype: :integer,
      default: 443,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.https.port here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.port"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.otp_app": [
      commented: false,
      datatype: :atom,
      default: :toss_bounty,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.https.otp_app here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.otp_app"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.keyfile": [
      commented: false,
      datatype: :binary,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.https.keyfile here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.keyfile"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.cacertfile": [
      commented: false,
      datatype: :binary,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.https.cacertfile here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.cacertfile"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.certfile": [
      commented: false,
      datatype: :binary,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.https.certfile here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.https.certfile"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.server": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.server here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.server"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.root": [
      commented: false,
      datatype: :binary,
      default: ".",
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.root here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.root"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.version": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.version here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.version"
    ],
    "toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base": [
      commented: false,
      datatype: :binary,
      doc:
        "Provide documentation for toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBountyWeb.Endpoint.secret_key_base"
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
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.username here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.username"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.database": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.database here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.database"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.password": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.password here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.password"
    ],
    "toss_bounty.Elixir.TossBounty.Repo.pool_size": [
      commented: false,
      datatype: :integer,
      default: 20,
      doc: "Provide documentation for toss_bounty.Elixir.TossBounty.Repo.pool_size here.",
      hidden: false,
      to: "toss_bounty.Elixir.TossBounty.Repo.pool_size"
    ],
    "toss_bounty.guardian_secret_key": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for toss_bounty.guardian_secret_key here.",
      hidden: false,
      to: "toss_bounty.guardian_secret_key"
    ],
    "toss_bounty.Elixir.Github.client_id": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.Github.client_id here.",
      hidden: false,
      to: "toss_bounty.Elixir.Github.client_id"
    ],
    "toss_bounty.Elixir.Github.client_secret": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.Github.client_secret here.",
      hidden: false,
      to: "toss_bounty.Elixir.Github.client_secret"
    ],
    "toss_bounty.Elixir.Github.redirect_uri": [
      commented: false,
      datatype: :atom,
      doc: "Provide documentation for toss_bounty.Elixir.Github.redirect_uri here.",
      hidden: false,
      to: "toss_bounty.Elixir.Github.redirect_uri"
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
      default: TossBounty.StripeProcessing.StripeSubscriptionCreator,
      doc: "Provide documentation for toss_bounty.subscription_deleter here.",
      hidden: false,
      to: "toss_bounty.subscription_deleter"
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
    "guardian.Elixir.Guardian.secret_key": [
      commented: false,
      datatype: :binary,
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
    ],
    "toss_bounty.front_end_url": [
      commented: false,
      default: "http://localhost:8000",
      doc: "The front end url of the TossBounty website",
      hidden: false,
      to: "toss_bounty.front_end_url"
    ]
  ],
  transforms: [],
  validators: []
]
