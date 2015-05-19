defmodule Wifi.Scanner.Iwlist do
  @moduledoc """
  Scanner implementation for the `iwlist`-command that is available on
  Linux systems.
  """

  @spec utility() :: binary
  def utility, do: "/usr/sbin/iwlist"

  @spec scan() :: [%Wifi.BaseStation{}]
  def scan do
    {result, 0} = System.cmd(utility, ["scan"])
    parse(result)
  end

  @spec parse(binary) :: [%Wifi.BaseStation{}]
  def parse(result) do
    result
    |> normalize_input
    |> Enum.reject(&(String.contains?(&1, "Scan completed"))) # Header
    |> Enum.map(&gather_fields/1)
  end

  defp normalize_input(input) do
    input
    |> String.split("Cell ")
    |> Enum.map(&(String.strip(&1)))
    |> Enum.reject(&(&1 == ""))
  end

  defp gather_fields(cell) do
    cell_lines = cell |> String.split("\n")
    
    %Wifi.BaseStation{
      ssid: get_field(cell_lines, "ESSID:") |> ssid_format,
      mac: get_field(cell_lines, "Address:") |> mac_format,
      rssi: get_field(cell_lines, "Signal level=") |> rssi_format,
      channel: get_field(cell_lines, "Channel:"),
      security: get_security(cell_lines)
    }
  end

  defp get_field(lines, identifier) do
    lines
    |> Enum.map(fn(line) ->
      if String.contains? line, identifier do
        String.split(line, identifier) |> List.last
      end
    end)
    |> Enum.reject(&(&1 == nil))
    |> List.first
  end

  defp get_security(lines) do
    lines
    |> Enum.map(fn(line) ->
      cond do
        String.contains? line, "IEEE" ->
          String.split(line, "/") |> List.last
        String.contains? line, "Group Cipher :" ->
          String.split(line, ": ") |> List.last
        String.contains? line, "Pairwise Ciphers" ->
          String.split(line, ": ") |> List.last
        String.contains? line, "Authentication Suites" ->
          String.split(line, ": ") |> List.last
        true -> ""
      end
    end)
    |> Enum.reject(&(&1 == ""))
  end

  defp ssid_format(ssid_field), do: ssid_field |> String.replace("\"", "")
  
  defp mac_format(mac_field), do: mac_field |> String.strip

  defp rssi_format(rssi_field) do
    rssi_field
    |> String.split(" ")
    |> List.first
    |> String.to_integer
  end
end
