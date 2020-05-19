# Pushup Counter

A proof of concept Flutter application using a(n) (w)earable bluetooth device from https://www.esense.io/ and the corresponding esense_flutter library. Just enter the number of pushups you want to do and the app will make a sound once it has detected that you have done that many pushups. 
Created alongside https://github.com/Aulig/Aulig.github.io for the great Mobile Computing & Internet of Things lecture by Prof. Beigl at the KIT.

## Main Screen:

![Main Screen](https://i.imgur.com/d9cHFLI.png)

## Graph Screen
The pushup detection works by collecting the earables acceleration along the x-axis (=raw data, red line) and searching for peaks in the filtered data (green line). This data can be viewed in the app after finishing a sequence of pushups and is displayed using charts_flutter.

![Graph Screen](https://i.imgur.com/4kA6gCL.png)

The detected peaks are circled in blue.

Other info: The packages flutter_blue and location are used to make sure bluetooth and location services are turned on before attempting to connect to the eSense device. Without this check the app would crash.

What needs improvement:
* Currently does not use MVVM to properly separate logic from UI.
* Connection state handling with the earable (especially disconnects).
* Pushup detection from the collected data can always be improved, currently it is often off by one (probably not detecting the first pushup).
