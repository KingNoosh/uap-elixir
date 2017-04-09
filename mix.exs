defmodule UserAgentParser.Mixfile do
  use Mix.Project

  def project do
    [app: :user_agent_parser,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      mod: {UserAgentParser, []},
      applications: [:yaml_elixir],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:"uap-core", git: "https://github.com/ua-parser/uap-core.git", branch: "master", app: false},
      {:yaml_elixir, "~> 1.3.0"},
      {:credo, "~> 0.7", only: [:dev, :test]}
    ]
  end
end
