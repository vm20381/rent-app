class RecoveryData {
  final DateTime createdAt;
  final double recoveryScore;
  final double restingHeartRate;
  final double hrvRmssdMilli;
  final double spo2Percentage;
  final double skinTempCelsius;

  RecoveryData({
    required this.createdAt,
    required this.recoveryScore,
    required this.restingHeartRate,
    required this.hrvRmssdMilli,
    required this.spo2Percentage,
    required this.skinTempCelsius,
  });

  factory RecoveryData.fromJson(Map<String, dynamic> json) {
    return RecoveryData(
      createdAt: DateTime.parse(json['created_at']),
      recoveryScore: json['score']['recovery_score'],
      restingHeartRate: json['score']['resting_heart_rate'],
      hrvRmssdMilli: json['score']['hrv_rmssd_milli'],
      spo2Percentage: json['score']['spo2_percentage'],
      skinTempCelsius: json['score']['skin_temp_celsius'],
    );
  }
}
