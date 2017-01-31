defmodule ExCloudinary.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_cloudinary,
     version: "0.3.0",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.0"},
     {:poison, "~> 3.1"},
     {:ex_doc, "~> 0.14.5", only: :dev}]
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
