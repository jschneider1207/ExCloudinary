# ExCloudinary

Elixir client for [Cloudinary](http://cloudinary.com/)

## Config

You need to add the following config in your `config.exs`:

        config :ex_cloudinary,
          name: "",
          api_key: "",
          api_secret: ""

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ex_cloudinary to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_cloudinary, "~> 0.0.1"}]
        end

  2. Ensure ex_cloudinary is started before your application:

        def application do
          [applications: [:ex_cloudinary]]
        end
