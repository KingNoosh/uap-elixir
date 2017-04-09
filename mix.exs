defmodule UserAgentParser.Mixfile do
  use Mix.Project

  def project do
    [
      app: :user_agent_parser,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
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
      {:yaml_elixir, "~> 1.3.0"},
      {:credo, "~> 0.7", only: [:dev, :test]}
    ]
  end

  defp description do
    """
      Elixir package to parse User Agent strings using BrowserScope's collection of regexes
    """
  end

  defp package do
    [
      files: ["lib", "config", "mix.exs", "README.md", "LICENCE", "vendor/uap-core/regexes.yaml"],
      licenses: ["MIT"],
      maintainers: ["Anosh Malik"],
      links: %{"GitHub" => "https://github.com/KingNoosh/uap-elixir"}
    ]
  end
end
