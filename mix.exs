defmodule ExCloudinary.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_cloudinary,
     version: "0.2.1",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.8.2"},
     {:poison, "~> 2.1"},
     {:earmark, "~> 0.2.1", only: :dev},
     {:ex_doc, "~> 0.11.4", only: :dev}]
  end

  defp description do
    """
    A wrapper around the HTTPoison.Base module for Cloudinary.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Sam Schneider"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sschneider1207/ExCloudinary"}]
  end
end
