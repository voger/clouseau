defmodule CL.Mixfile do
  use Mix.Project
  
  @links %{
    "GitHub" => "https://github.com/voger/clouseau"
  }

  @version "0.5.0"

  def project do
    [
      app: :clouseau,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      description: description(),
      name: "Clouseau",
      source_url: Map.get(@links, "GitHub")
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", runtime: false, optional: true},
      {:ex_doc, "~> 0.19", runtime: false, only: :dev}
    ]
  end

  defp description() do
    "Debugging tool. A wrapper around IO.inspect that provides some enhancements"
  end

  defp package() do
    [
      files: ["lib/**/*.ex", "mix.exs", "README.md", "LICENSE*", "CHANGELOG.md"],
      maintainers: ["voger"],
      licenses: ["MIT"],
      links: @links
    ]
  end

  defp docs() do
    [
      extras: ["README.md"],
      main: "readme"
    ]
  end
end
