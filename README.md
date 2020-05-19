# Pushup Counter

A proof of concept Flutter application using a(n) (w)earable bluetooth device from https://www.esense.io/. Just enter the number of pushups you want to do and the app will make a sound once it has detected that you have done that many pushups. 
Created alongside https://github.com/Aulig/Aulig.github.io for the great Mobile Computing & Internet of Things lecture by Prof. Beigl at the KIT.

## Main Screen:

![Main Screen](https://i.imgur.com/4kA6gCL.png)

## Graph Screen
The pushup detection works by collecting the earables acceleration along the x-axis and searching for peaks in the filtered data:

![Graph Screen](https://i.imgur.com/4kA6gCL.png)

(The detected peaks are circled in blue)


What needs improvement:
* Currently does not use MVVM to properly separate logic from UI.
* Connection state handling with the earable (especially disconnects).
* Pushup detection from the collected data can always be improved, currently it is often off by one (probably not detecting the first pushup).
