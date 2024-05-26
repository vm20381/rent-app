class BodyMeasurement {
  final double heightMeter;
  final double weightKilogram;
  final int maxHeartRate;

  BodyMeasurement(
      {required this.heightMeter,
      required this.weightKilogram,
      required this.maxHeartRate});

  factory BodyMeasurement.fromJson(Map<String, dynamic> json) {
    return BodyMeasurement(
      heightMeter: json['height_meter'],
      weightKilogram: json['weight_kilogram'],
      maxHeartRate: json['max_heart_rate'],
    );
  }
}
