defmodule TossBounty.Mixfile do
  use Mix.Project

  def project do
    [
      app: :toss_bounty,
      version: "0.3.3",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {TossBounty, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :ja_resource,
        :comeonin,
        :guardian,
        :ja_serializer,
        :joken,
        :corsica,
        :postgrex,
        :tentacat,
        :timex,
        :timex_ecto,
        :stripity_stripe,
        :oauth2,
        :scrivener_ecto,
        :bamboo,
        :toml
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:joken, "~> 1.1"},
      {:guardian, "~> 1.0"},
      # JSON API
      {:ja_serializer, "~> 0.12.0"},
      {:ja_resource, "~> 0.3.0"},
      {:corsica, "~> 1.0"},
      {:distillery, "~> 2.0", runtime: false},
      {:tentacat, github: "trodrigu/tentacat"},
      {:phoenix_custom_generators, "~> 1.0.6"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.2"},
      {:stripity_stripe, "~> 2.0.0-beta"},
      {:oauth2, "~> 0.9"},
      {:scrivener_ecto, "~> 1.0"},
      {:bamboo, "~> 1.0"},
      {:toml, "~> 0.5.1"},
      {:plug_cowboy, "~> 1.0"},
      {:bcrypt_elixir, "~> 0.12"},
      {:jason, "~> 1.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
