defmodule Wifi.BaseStation do
  @moduledoc """
  A struct to store information about Wifi base stations.

    * **ssid** the given name of the base station
    * **mac** the unique MAC-address of the base station
    * **rssi** the signal strength
    * **channel** the channel that the base station broadcasts with
    * **ht** whether or not high throughput mode is enabled
    * **cc** Country code. This can be misleading.
    * **security** A list of security modes the base station uses

  The `Wifi.scanner` returns a list of `%Wifi.BaseStation{}`-structs
  making it easy to pattern match on the output.
  """
  @type t :: %Wifi.BaseStation{
    ssid: binary | nil,
    mac: binary | nil,
    rssi: integer,
    channel: binary | nil,
    ht: boolean,
    cc: binary | nil,
    security: list | nil
  }

  defstruct [
    ssid: nil,
    mac: nil,
    rssi: 0,
    channel: nil,
    ht: false,
    cc: nil,
    security: nil
  ]
end
