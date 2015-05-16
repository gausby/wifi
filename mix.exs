defmodule Wifi.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip
  defp description do
    """
    Various utility functions for working with the local Wifi network in Elixir.
    These functions are mostly useful in scripts that could benefit from knowing
    the current location of the computer or the Wifi surroundings.
    """
  end

  def project do
    [app: :wifi,
     version: @version,
     description: description,
     package: package,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.6"},
     {:poison, "~> 1.4.0"}]
  end

  defp package do
    %{
      licenses: ["MIT"],
      contributors: ["Martin Gausby"],
      links: %{ "GitHub" => "https://github.com/gausby/wifi"},
      files: ~w(lib config mix.exs LICENSE VERSION README*)
    }
  end
end
