import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mciot_wearable/data_analyzer.dart';
import 'package:mciot_wearable/esense_manager.dart';

class Workout extends StatefulWidget {

	DataAnalyzer da;

	Workout(this.da);

	@override
	State<StatefulWidget> createState() {
		return new _WorkoutState(da);
	}
}

class _WorkoutState extends State {

	DataAnalyzer da;

	_WorkoutState(this.da);

	static AudioCache audioCache = new AudioCache();

	TextEditingController pushupCountController = new TextEditingController();

	OwnEsenseManager esenseManager = new OwnEsenseManager();

	Future<void> startSession(String pushupCount) async {

		da.clearData();

		await esenseManager.showConnectDialog(context, false);

		int pucount = int.parse(pushupCount);

		Timer(Duration(seconds: 10), () {
			audioCache.play("bell.mp3");
		});


		int lastCount = 0;

		esenseManager.getSensorSubscription((event) {

			if (lastCount < pucount) {

				da.addValue(event.accel[0]);

				int p = da.countPeaks();

				if (p > lastCount) {

					lastCount = p;
					if (p == pucount) {

						audioCache.play("bell.mp3");
					}
				}
			}
		});
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
						],
						// Only numbers can be entered
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