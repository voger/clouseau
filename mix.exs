defmodule CL.Mixfile do
  use Mix.Project
  
  @links %{
    "GitHub" => "https://github.com/voger/clouseau"
  }

  def project do
    [
      app: :clouseau,
      version: "0.3.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
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
      {:credo, "~> 0.8", runtime: false, optional: true}
    ]
  end

  defp description() do
    "Debugging tool. A wrapper around IO.inspect that provides some enhancements"
  end

  defp package() do
    [
      files: ["lib/*.ex", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["voger"],
      licenses: ["MIT"],
      links: @links
    ]
  end
end
