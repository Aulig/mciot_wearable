import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EarableInfo extends StatefulWidget {

	@override
	_EarableInfoState createState() => _EarableInfoState();
}

class _EarableInfoState extends State {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('eSense Info'),
			),
			body: Align(
				alignment: Alignment.topLeft,
				child: ListView(
					children: [
						Text('eSense Device Status: \t$_deviceStatus'),
						Text('eSense Device Name: \t$_deviceName'),
						Text('eSense Battery Level: \t$_voltage'),
						Text('eSense Button Event: \t$_button'),
						Text(''),
						Text('$_event'),
					],
				),
			),
			floatingActionButton: new FloatingActionButton(
				// a floating button that starts/stops listening to sensor events.
				// is disabled until we're connected to the device.
				onPressed:
				(!ESenseManager.connected) ? null : (!sampling)
					? _startListenToSensorEvents
					: _pauseListenToSensorEvents,
				tooltip: 'Listen to eSense sensors',
				child: (!sampling) ? Icon(Icons.play_arrow) : Icon(Icons.pause),
			),
		);

	}
}