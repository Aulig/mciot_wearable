import 'package:flutter/material.dart';
import 'package:mciot_wearable/appbar_drawer.dart';
import 'package:mciot_wearable/earable_info.dart';
import 'package:mciot_wearable/graphs.dart';
import 'package:mciot_wearable/workout.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => _MyAppState();
}


//IF CRASHING ON STARTUP ENABLE LOCATION & BLUETOOTH
//apparently executing 2 commands at the same time doesnt work, await callback and then execute next one

class _MyAppState extends State<MyApp> {


	Widget body = EarableInfo();

	@override
	void initState() {
		super.initState();
	}

	Widget build(BuildContext context) {
		return MaterialApp(
//			color: Color.fromARGB(255, 246, 178, 33),
			theme: ThemeData(),
			darkTheme: ThemeData.dark(),
			home: new AppbarDrawer("eSense Info", new EarableInfo()),
			routes: <String, WidgetBuilder>{
				'/workout': (BuildContext context) => new AppbarDrawer("Workout", new Workout()),
				'/info': (BuildContext context) => new AppbarDrawer("eSense Info", new EarableInfo()),
				'/graphs': (BuildContext context) => new AppbarDrawer("Graphs", new Graphs()),
			},
		);
	}
}