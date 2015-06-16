defmodule Wifi.Scanner.Netsh do
  @moduledoc """
  Scanner implementation for the `iwlist`-command that is available on
  Linux systems.
  """
    @spec utility() :: binary
    def utility, do: "C:/Windows/System32/netsh.exe"

    @spec scan() :: [%Wifi.BaseStation{}]
    def scan do
      {result, 0} = System.cmd(utility, ["wlan","show","networks","mode=Bssid"])
      parse(result)
    end

    @spec parse(binary) :: [%Wifi.BaseStation{}]
    def parse(result) do
      result
      |> normalize_input
      |> Enum.reject(&(String.contains?(&1, "Interface name"))) # Header
      |> Enum.map(&gather_fields/1)
    end

    defp normalize_input(input) do
      input
      |> String.split(~r([^B]SS))
      |> Enum.map(&(String.strip(&1)))
    end

    defp gather_fields(cell) do
      lines = cell |> String.split("\n")
      %Wifi.BaseStation{
        ssid: get_field(lines,"ID"),
        mac: get_field(lines,"BSSID"),
        rssi: get_field(lines,"Signal") |> String.replace("%",""),
        channel: get_field(lines,"Channel"),
        security: get_field(lines,"Encryption")
      }
    end

    defp get_field(lines, identifier) do
      lines |> Enum.find(&(String.contains?(&1,identifier))) |> string_format
    end

    defp string_format(string) do
      string |> String.split(" : ") |> List.last |> String.strip
    end
end
