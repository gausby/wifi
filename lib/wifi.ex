defmodule Wifi do
  @moduledoc """
  Various utility functions for working with the local Wifi network in 
  Elixir. These functions are mostly useful in scripts that could benefit
  from knowing the current location of the computer or the Wifi
  surroundings.
  """

  @doc """
  Will scan the local Wifi network and return information about the local
  base stations.
  """
  defdelegate scan, to: Wifi.Scanner

  @doc """
  Will attempt to triangulate the current location of the computer running
  the script. This is done using the Google Location APIs by sending
  information about the current Wifi surroundings and getting the current
  location.
  """
  defdelegate location, to: Wifi.Location

end
