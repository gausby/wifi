defmodule Wifi.Scanner do
  @moduledoc """
  Provide functions for scanning the base stations on the local Wifi.

      iex> Wifi.Scanner.scan

  will return a list of base stations at the current location.
  """

  @doc """
  Scan the local wifi for base stations and return information about them.
  """
  # Attempt to find a scanner implementation for the current operating system.
  # This will only run at initialization, so please restart the application if
  # you change the the underlying operating system while the program is running.
  cond do
    # Microsoft Windows systems, please help

    # Mac OS X systems
    File.exists? Wifi.Scanner.Airport.utility ->
      defdelegate scan, to: Wifi.Scanner.Airport

    # Linux
    File.exists? Wifi.Scanner.Iwlist.utility ->
      defdelegate scan, to: Wifi.Scanner.Iwlist
    
    #unix, etc, please help

    # fallback, raise an exception!
    true ->
      raise "Please implement a Wifi.Scanner this operating system."
  end

end
