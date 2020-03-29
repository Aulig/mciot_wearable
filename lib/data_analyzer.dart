class DataAnalyzer {

	var _times = [];
	var _values = [];
	var _smoothedValues = [];
	var _averagedValues = [];
	var detections = [];

	static const int TREND_LENGTH_FOR_PEAK = 10;
	static const int LAG = 15;
	static const double ALPHA = 0.4;

	void clearData() {

		_times = [];
		_values = [];
		_smoothedValues = [];
		_averagedValues = [];
	}

	void addValue(int value) {
		_values.add(value);
		_times.add(DateTime.now());

		if (_smoothedValues.isEmpty) {
			_smoothedValues.add(value);
		}
		else {
			_smoothedValues.add(value * (1 - ALPHA) + _smoothedValues[_smoothedValues.length - 1] * ALPHA);
		}

		if (_smoothedValues.length - LAG >= 0) {
			_averagedValues.add(average(_smoothedValues.sublist(_smoothedValues.length - LAG)));
		}
		else {
			_averagedValues.add(average(_smoothedValues));
		}
	}

	double average(var values) {
		return values.reduce((a, b) => a + b) / values.length;
	}

	int countPeaks() {

		detections = [];

		int peaks = 0;

		int upwardsTrendLength = 0;
		int downwardsTrendLength = 0;

		for (int i = 1; i < _averagedValues.length; i++) {
			if (_averagedValues[i] >= _averagedValues[i - 1]) {
				upwardsTrendLength++;

				if (upwardsTrendLength > TREND_LENGTH_FOR_PEAK) {
//					if (downwardsTrendLength > TREND_LENGTH_FOR_PEAK) {
//
//						lows++;
//					}

					downwardsTrendLength = 0;
				}
			}
			else {
				downwardsTrendLength++;

				if (downwardsTrendLength > TREND_LENGTH_FOR_PEAK) {
					if (upwardsTrendLength > TREND_LENGTH_FOR_PEAK) {
						detections.add(i - 1);
						peaks++;
					}

					upwardsTrendLength = 0;
				}
			}
		}

		return peaks;
	}

	List<AccelerationAtTime> getData() {

		List<AccelerationAtTime> data = [];

		for (int i = 0; i < _values.length; i++) {

			data.add(new AccelerationAtTime(_times[i], _values[i].toDouble()));
		}

		return data;
	}
	List<AccelerationAtTime> getSmoothedData() {

		List<AccelerationAtTime> data = [];

		for (int i = 0; i < _smoothedValues.length; i++) {

			data.add(new AccelerationAtTime(_times[i], _smoothedValues[i].toDouble()));
		}

		return data;
	}
	List<AccelerationAtTime> getAveragedData() {

		List<AccelerationAtTime> data = [];

		for (int i = 0; i < _averagedValues.length; i++) {

			data.add(new AccelerationAtTime(_times[i], _averagedValues[i].toDouble()));
		}

		return data;
	}

	List<AccelerationAtTime> getDetections() {

		List<AccelerationAtTime> data = [];

		for (int i = 0; i < detections.length; i++) {

			data.add(new AccelerationAtTime(_times[detections[i]], 0));
		}

		return data;
	}
}

class AccelerationAtTime {

	final DateTime time;
	final double acceleration;

	AccelerationAtTime(this.time, this.acceleration);
}