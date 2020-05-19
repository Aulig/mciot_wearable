# Pushup Counter

A proof of concept Flutter application using a(n) (w)earable bluetooth device from https://www.esense.io/. Created alongside https://github.com/Aulig/Aulig.github.io for the great Mobile Computing & Internet of Things lecture by Prof. Beigl at the KIT.

What needs improvement:
* Currently does not use MVVM to properly separate logic from UI.
* Connection state handling with the earable (especially disconnects).
* Pushup detection from the collected data can always be improved, currently it is often off by one (probably not detecting the first pushup).
