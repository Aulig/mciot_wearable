import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:mciot_wearable/data_analyzer.dart';

class Graphs extends StatefulWidget {

	DataAnalyzer da;

	Graphs(this.da);

	@override
	State<StatefulWidget> createState() {
		return new _GraphState(da);
	}
}

class _GraphState extends State {

	DataAnalyzer da;

	_GraphState(this.da);

	@override
	Widget build(BuildContext context) {
		return new charts.TimeSeriesChart(_createData(),
			animate: true);
	}

	/// Create one series with sample hard coded data.
	List<charts.Series<AccelerationAtTime, DateTime>> _createData() {

//		final myAnnotationData2 = da.getDetections();
		return [
			new charts.Series<AccelerationAtTime, DateTime>(
				id: 'Detections',
				colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
				domainFn: (AccelerationAtTime aat, _) => aat.time,
				// No measure values are needed for symbol annotations.
				measureFn: (_, __) => null,
				data: da.getDetections(),
			),
			new charts.Series<AccelerationAtTime, DateTime>(
				id: 'Raw Values',
				colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
				domainFn: (AccelerationAtTime aat, _) => aat.time,
				measureFn: (AccelerationAtTime aat, _) => aat.acceleration,
				data: da.getData(),
			),
			new charts.Series<AccelerationAtTime, DateTime>(
				id: 'Smoothed Values',
				colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
				domainFn: (AccelerationAtTime aat, _) => aat.time,
				measureFn: (AccelerationAtTime aat, _) => aat.acceleration,
				data: da.getSmoothedData(),
			),
			new charts.Series<AccelerationAtTime, DateTime>(
				id: 'Smoothed & Averaged Values',
				colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
				domainFn: (AccelerationAtTime aat, _) => aat.time,
				measureFn: (AccelerationAtTime aat, _) => aat.acceleration,
				data: da.getAveragedData(),
			)
		];
	}
}