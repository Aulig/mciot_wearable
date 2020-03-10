import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';

class OwnEsenseManager {

	String deviceName;
	bool connected = false;

	void showConnectDialog(BuildContext context, bool failedBefore) {
		TextEditingController esenseNameController = new TextEditingController();

		showDialog(
			context: context,
			barrierDismissible: false, //can't be closed by tapping outside of the dialogue, only buttons work
			builder: (BuildContext context) {
				return new AlertDialog(
					title: new Text(failedBefore ? "Connection failed. Try again." : "Connect to your eSense"),
					content: new TextField(
						controller: esenseNameController,
						decoration: new InputDecoration(labelText: "How many pushups can you do?"),
						onSubmitted: (String esenseName) async {
							Navigator.of(context).pop();

							if (!await connect(esenseName)) {
								showConnectDialog(context, true);
							}
						},
					),
					actions: <Widget>[

						new FlatButton(
							child: new Text("Connect"),
							onPressed: () async {
								Navigator.of(context).pop();

								if (!await connect(esenseNameController.text)) {
									showConnectDialog(context, true);
								}
							},
						)
						,
					]
				);
			},
		);
	}

	Future<bool> connect(String eSenseName) async {

		// if you want to get the connection events when connecting, set up the listener BEFORE connecting...
//		ESenseManager.connectionEvents.listen((event) {
//			print('CONNECTION event: $event');
//
//			// when we're connected to the eSense device, we can start listening to events from it
//			if (event.type == ConnectionType.connected) {
//
//				connected = true;
//				_listenToESenseEvents();
//			}
//		});

		if(connected = await ESenseManager.connect(eSenseName)) {

			_listenToESenseEvents();
		}

		return connected;
	}

	void buttonPressed() {


	}

	void _listenToESenseEvents() async {
		ESenseManager.eSenseEvents.listen((event) {
			print('ESENSE event: $event');

				switch (event.runtimeType) {
//					case DeviceNameRead:
//						_deviceName = (event as DeviceNameRead).deviceName;
//						break;
//					case BatteryRead:
//						_voltage = (event as BatteryRead).voltage;
//						break;
					case ButtonEventChanged:
						if ((event as ButtonEventChanged).pressed) {

							buttonPressed();
						}
						break;
//					case AccelerometerOffsetRead:
//						break;
//					case AdvertisementAndConnectionIntervalRead:
//						break;
//					case SensorConfigRead:
//						break;
				}

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
}