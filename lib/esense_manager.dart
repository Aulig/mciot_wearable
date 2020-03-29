import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';

class OwnEsenseManager {

	String deviceName;
	bool connected = false;

	Future<bool> showConnectDialog(BuildContext context, bool failedBefore) {
		TextEditingController esenseNameController = new TextEditingController(text: "eSense-0678");

		Completer<bool> connectionCompleter = new Completer();

		showDialog(
			context: context,
			barrierDismissible: false, //can't be closed by tapping outside of the dialogue, only buttons work
			builder: (BuildContext context) {
				return new AlertDialog(
					title: new Text(failedBefore
						? "Connection failed. Make sure Location Services & Bluetooth are enabled!"
						: "Connect to your eSense"),
					content: new TextField(
						controller: esenseNameController,
						decoration: new InputDecoration(labelText: "Device Name"),
						onSubmitted: (String esenseName) async {
							Navigator.of(context).pop();

							if (!await _connect(esenseName)) {
								showConnectDialog(context, true);
							}
							else {
								connectionCompleter.complete(true);
							}
						},
					),
					actions: <Widget>[

						new FlatButton(
							child: new Text("Connect"),
							onPressed: () async {
								Navigator.of(context).pop();

								if (!await _connect(esenseNameController.text)) {
									showConnectDialog(context, true);
								}
								else {
									connectionCompleter.complete(true);
								}
							},
						)
						,
					]
				);
			},
		);

		return connectionCompleter.future;
	}

	Future<bool> _connect(String eSenseName) async {
		Completer<bool> completer = new Completer();

		Location location = new Location();

		bool _serviceEnabled;

		_serviceEnabled = await location.serviceEnabled();
		if (!_serviceEnabled) {
			completer.complete(false);
			return completer.future;
		}

		FlutterBlue flutterBlue = FlutterBlue.instance;

		if (!await flutterBlue.isOn) {
			completer.complete(false);
			return completer.future;
		}

		await ESenseManager.connect(eSenseName);

		ESenseManager.connectionEvents.listen((event) {
			// when we're connected to the eSense device, we can start listening to events from it
			switch (event.type) {
				case ConnectionType.connected:
					completer.complete(true);
					connected = true;
					print("Connected");
					break;
				case ConnectionType.device_not_found:
					completer.complete(false);
					print("Connection failed");
					break;
				case ConnectionType.unknown:
					print("Unknown connection");
					break;
				case ConnectionType.disconnected:
					print("Disconnected");
					break;
				case ConnectionType.device_found:
				// TODO: Handle this case.
					break;
			}
		});

		return completer.future;
	}

	StreamSubscription getSensorSubscription(Function onData) {
		return ESenseManager.sensorEvents.listen(onData);
	}
}