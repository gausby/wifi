defmodule Wifi.Location do
  @moduledoc """
  Utility functions for estimating the physical location using wifi base
  stations.
  """

  alias Wifi.BaseStation

  @doc """
  Estimate the location of the Wifi base stations using Google browser
  location APIs.

      iex> Wifi.Location.location
      %{"accuracy" => 150, "location" => %{"lat" => 55.6664459, "lng" => 12.5460273}, "status" => "OK"}

  This function is delegated to Wifi, so you could access it by simply 
  writing `Wifi.location`.
  """
  def location, do: location(Wifi.scan)
  def location(base_stations) when is_list(base_stations) do
    url = generate_url!(base_stations)
    {:ok, response} = HTTPoison.request(:post, url, "", [{:Accept, "application/json"}])

    Poison.decode!(response.body)
  end

  @api_url "https://maps.googleapis.com/maps/api/browserlocation/json"
  @api_opts "browser=firefox&sensor=true"
  defp generate_url!(base_stations) do
    qs = Enum.map_join(base_stations, "&wifi=", fn %BaseStation{ssid: ssid, mac: mac, rssi: rssi} ->
      URI.encode("mac:#{mac}|ssid:#{ssid}|ss:#{rssi}")
    end)

    "#{@api_url}?#{@api_opts}&wifi=#{qs}"
  end

end
