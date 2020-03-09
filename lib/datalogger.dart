import 'dart:io';

import 'package:esense_flutter/esense.dart';
import 'package:path_provider/path_provider.dart';

class DataLogger {

	Future<File> logFile;

	DataLogger(String logName) {

		logFile = getApplicationDocumentsDirectory().then((Directory d) {

			return new File(d.path + "/$logName.csv");
		});
	}

	logSensorEvent(SensorEvent event) async {

		(await logFile).writeAsStringSync("${new DateTime.now().millisecondsSinceEpoch}," + event.gyro.join(",") + "," + event.accel.join(",") + "\n", mode: FileMode.append);
	}
}