import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mciot_wearable/appbar_drawer.dart';

class Workout extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return new _WorkoutState();
	}
}

class _WorkoutState extends State {

	TextEditingController pushupCountController = new TextEditingController();

	void startSession(String pushupCount) {


	}

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			mainAxisSize: MainAxisSize.min,

			children: <Widget>[

				new Padding(
					padding: EdgeInsets.all(16),
					child: new TextField(
					controller: pushupCountController,
					decoration: new InputDecoration(labelText: "How many pushups can you do?"),
					keyboardType: TextInputType.number,
					inputFormatters: <TextInputFormatter>[
						WhitelistingTextInputFormatter.digitsOnly
					], // Only numbers can be entered
						onSubmitted: startSession,
				)),
				new FlatButton(
					onPressed: () {

						startSession(pushupCountController.text);
					},
					child: new Text("Start")
				),
			],
		);
	}
}