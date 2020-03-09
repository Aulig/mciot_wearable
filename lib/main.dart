import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:mciot_wearable/earable_info.dart';

import 'datalogger.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => _MyAppState();
}


//IF CRASHING ON STARTUP ENABLE LOCATION & BLUETOOTH
//apparently executing 2 commands at the same time doesnt work, await callback and then execute next one

class _MyAppState extends State<MyApp> {
	String _deviceName = 'Unknown';
	double _voltage = -1;
	String _deviceStatus = '';
	bool sampling = false;
	String _event = '';
	String _button = 'not pressed';

	// the name of the eSense device to connect to -- change this to your own device.
	String eSenseName = 'eSense-0678';

	@override
	void initState() {
		super.initState();
		print("IF CRASHING ON STARTUP ENABLE LOCATION & BLUETOOTH");



		_connectToESense();
	}

	Future<void> _connectToESense() async {
		bool con = false;

		// if you want to get the connection events when connecting, set up the listener BEFORE connecting...
		ESenseManager.connectionEvents.listen((event) {
			print('CONNECTION event: $event');

			// when we're connected to the eSense device, we can start listening to events from it
			if (event.type == ConnectionType.connected) _listenToESenseEvents();

			setState(() {
				switch (event.type) {
					case ConnectionType.connected:
						_deviceStatus = 'connected';
						break;
					case ConnectionType.unknown:
						_deviceStatus = 'unknown';
						break;
					case ConnectionType.disconnected:
						_deviceStatus = 'disconnected';
						break;
					case ConnectionType.device_found:
						_deviceStatus = 'device_found';
						break;
					case ConnectionType.device_not_found:
						_deviceStatus = 'device_not_found';
						break;
				}
			});
		});

		con = await ESenseManager.connect(eSenseName);

		setState(() {
			_deviceStatus = con ? 'connecting' : 'connection failed';
		});
	}

	void _listenToESenseEvents() async {
		ESenseManager.eSenseEvents.listen((event) {
			print('ESENSE event: $event');

			setState(() {
				switch (event.runtimeType) {
					case DeviceNameRead:
						_deviceName = (event as DeviceNameRead).deviceName;
						break;
					case BatteryRead:
						_voltage = (event as BatteryRead).voltage;
						break;
					case ButtonEventChanged:
						_button = (event as ButtonEventChanged).pressed ? 'pressed' : 'not pressed';
						break;
					case AccelerometerOffsetRead:
					// TODO
						break;
					case AdvertisementAndConnectionIntervalRead:
					// TODO
						break;
					case SensorConfigRead:
					// TODO
						break;
				}
			});
		});

		_getESenseProperties();
	}

	void _getESenseProperties() async {
		// get the battery level every 10 secs
		Timer.periodic(Duration(seconds: 10), (timer) async => await ESenseManager.getBatteryVoltage());

		// wait 2, 3, 4, 5, ... secs before getting the name, offset, etc.
		// it seems like the eSense BTLE interface does NOT like to get called
		// several times in a row -- hence, delays are added in the following calls
		Timer(Duration(seconds: 2), () async => await ESenseManager.getDeviceName());
		Timer(Duration(seconds: 3), () async => await ESenseManager.getAccelerometerOffset());
		Timer(Duration(seconds: 4), () async => await ESenseManager.getAdvertisementAndConnectionInterval());
		Timer(Duration(seconds: 5), () async => await ESenseManager.getSensorConfig());
	}

	StreamSubscription subscription;

	void _startListenToSensorEvents() async {

		DataLogger dl = new DataLogger("${new DateTime.now().millisecondsSinceEpoch}");

		// subscribe to sensor event from the eSense device
		subscription = ESenseManager.sensorEvents.listen((event) {
			print('SENSOR event: $event');

			setState(() {
				_event = event.toString();
			});
			dl.logSensorEvent(event);
		});
		setState(() {
			sampling = true;
		});
	}

	void _pauseListenToSensorEvents() async {
		subscription.cancel();
		setState(() {
			sampling = false;
		});
	}

	void dispose() {
		_pauseListenToSensorEvents();
		ESenseManager.disconnect();
		super.dispose();
	}

	Widget build(BuildContext context) {
		return MaterialApp(
			routes: <String, WidgetBuilder>{
				'/info': (BuildContext context) => EarableInfo(),
				'/graphs': (BuildContext context) => WebViewPage(initialTitle: 'page B'),
				'/c': (BuildContext context) => WebViewPage(initialTitle: 'page C'),
			},
			theme: ThemeData(),
			darkTheme: ThemeData.dark(),
			home: EarableInfo(),
		);
	}
}