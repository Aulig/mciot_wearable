import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppbarDrawer extends StatelessWidget {

	String title;
	Widget body;

	AppbarDrawer(this.title, this.body);

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: AppBar(
				title: Text(title),
			),
			body: body,
			drawer: new Drawer(
				child: new ListView(
					children: <Widget>[
						DrawerHeader(
							decoration: BoxDecoration(
								color: Colors.blue,
							),
							child: Text(
								'Drawer Header',
								style: TextStyle(
									color: Colors.white,
									fontSize: 24,
								),
							),
						),
						ListTile(
							title: Text("Workout",
								style: new TextStyle(fontSize: 16,),
							),
							leading: new Icon(Icons.directions_run),
							onTap: () {
								Navigator.pop(context);

								Navigator.pushNamed(context, "/workout");
							},
						),
						ListTile(
							title: Text("Graphs",
								style: new TextStyle(fontSize: 16,),
							),
							leading: new Icon(Icons.show_chart),
							onTap: () {
								Navigator.pop(context);

								Navigator.pushNamed(context, "/graphs");
							},
						),
						ListTile(
							title: Text("eSense Info",
								style: new TextStyle(fontSize: 16,),
							),
							leading: new Icon(Icons.info),
							onTap: () {
								Navigator.pop(context);

								Navigator.pushNamed(context, "/info");
							},
						),
					]
				)
			),
		);;
	}

}