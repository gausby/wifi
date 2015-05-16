defmodule Wifi.Scanner.Airport do
  @moduledoc """
  Scanner implementation for the **airport**-command that is available on
  Mac OS X systems.
  """

  alias Wifi.BaseStation

  @spec utility() :: binary
  def utility,
    do: "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

  @spec scan() :: [%Wifi.BaseStation{}]
  def scan do
    {result, 0} = System.cmd(utility, ["-s"])
    parse(result)
  end

  @spec parse(binary) :: [%Wifi.BaseStation{}]
  def parse(result) do
    result
    |> normalize_input
    |> Enum.map(&scan_for_ssid_and_bssid/1)
    |> Enum.reject(&(&1 == nil))
    |> Enum.map(fn {mac, ssid, rest} ->
      [rssi, channel, ht, cc | security] = String.split(rest)

      %BaseStation{
        mac: mac,
        ssid: ssid,
        rssi: String.to_integer(rssi),
        cc: get_country(cc),
        ht: high_throughput_enabled?(ht),
        channel: channel,
        security: parse_securities(security)
      }
    end)
  end

  defp normalize_input(input) do
    input
    |> String.split("\n")
    |> Enum.drop(1) # the first line is a header
    |> Enum.map(&(String.strip(&1)))
    |> Enum.reject(&(&1 == ""))
  end

  # ssid and bssid ----------------------------------------------------
  defp scan_for_ssid_and_bssid(line) do
    case do_scan_for_ssid_and_bssid(line, []) do
      {bssid, ssid, rest} -> {bssid, ssid, rest}
      {:error, _reason} -> nil
    end
  end

  defp do_scan_for_ssid_and_bssid(<<
      " ",
      a::binary-size(2), ":", b::binary-size(2), ":", c::binary-size(2), ":",
      d::binary-size(2), ":", e::binary-size(2), ":", f::binary-size(2), rest::binary
      >>, ssid_acc) do

    ssid = ssid_acc |> Enum.reverse |> Enum.join()
    {"#{a}:#{b}:#{c}:#{d}:#{e}:#{f}", ssid, rest}
  end
  defp do_scan_for_ssid_and_bssid(<<a::binary-size(1), rest::binary>>, ssid_acc),
    do: do_scan_for_ssid_and_bssid(rest, [a | ssid_acc])
  defp do_scan_for_ssid_and_bssid("", _),
    do: {:error, "invalid input"}


  # get country -------------------------------------------------------
  defp get_country("--"), do: nil
  defp get_country(country_code), do: country_code


  # get high trough put status ----------------------------------------
  defp high_throughput_enabled?("Y"), do: true
  defp high_throughput_enabled?(_), do: false


  # security
  defp parse_securities(securities) when is_list(securities) do
    Enum.reduce(securities, [], fn security, acc ->
      security = Regex.named_captures(
        ~r/(?<type>[^\(]*)\((?<auth>[^\/]*)\/(?<unicast>[^\/]*)\/(?<group>[^\/]*)\)/,
        security
      )
      security = security |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end) |> Enum.into(%{})
      [security | acc]
    end)
  end
end
