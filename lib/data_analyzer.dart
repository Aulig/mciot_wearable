class DataAnalyzer {

	var _values = [];
	var _smoothedValues = [];
	var _averagedValues = [];

	static const int TREND_LENGTH_FOR_PEAK = 10;
	static const int LAG = 20;
	static const double ALPHA = 0.4;

	void addValue(int value) {
		_values.add(value);

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
						peaks++;
					}

					upwardsTrendLength = 0;
				}
			}
		}

		return peaks;
	}
}