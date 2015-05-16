Wifi for Elixir
===============
Various utility functions for working with the local Wifi network in Elixir. These functions are mostly useful in scripts that could benefit from knowing the current location of the computer or the Wifi surroundings.

This project is inspired by [wifi-location](https://github.com/wearefractal/wifi-location) by [Fractal](https://github.com/wearefractal) and [node-wifiscanner](https://github.com/mauricesvay/node-wifiscanner) by [Maurice Svay](https://github.com/mauricesvay).

**Please help**: So far the project will only work on Mac OS X. If you are running Windows or Linux (or any of the BSDs) please make a scanner-wrapper that implements `Wifi.Scanner.*name*.utility/0`, `Wifi.Scanner.*name*.scan/0` and `Wifi.Scanner.*name*.parse/1`. Refer to the `Wifi.Scanner.Airport` implementation. On Windows the utility `netsh` should be helpful, and on Linux the `iwlist` should do the job. Thanks.


Features
--------
Currently the project implements the following

  * `Wifi.scan/0` return a list of local Wifi base stations with information such as security modes and signal strength.
  * `Wifi.location/0` will attempt to triangulate the psychical location of the computer running the script based on triangulation using the local Wifi surroundings and Googles location APIs.

Pull requests or feature requests are more than welcome if you have suggestions and ideas on how to work with Wifi. Also, I (Martin Gausby) needs help making this run on Unix-like and Windows systems. Current only Mac OS X is supported.


Installation
------------
The project is available on [hex.pm](https://hex.pm/) as [Wifi](http://hex.pm/packages/wifi). Add it to your mix dependencies using the decided version, ie: `{:wifi, "~> 0.0.1"}`, and be sure to add `:wifi` to the `applications` list, as we need to start the Hackney application for the `Wifi.location/0` function to work.


License
-------
The MIT License (MIT)

Copyright (c) 2015 Martin Gausby

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
