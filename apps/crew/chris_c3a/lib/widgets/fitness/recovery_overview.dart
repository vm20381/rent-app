import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../models/fitness/recovery_data.dart';

class RecoveryOverviewWidget extends StatelessWidget {
  final RecoveryData? recoveryData;

  const RecoveryOverviewWidget({super.key, required this.recoveryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 120.0,
          lineWidth: 13.0,
          animation: true,
          percent: (recoveryData?.recoveryScore ?? 0) / 100,
          center: Text(
            "${recoveryData?.recoveryScore.toStringAsFixed(1)}%",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          footer: const Text(
            "Recovery Score",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: _getColorForScore(recoveryData?.recoveryScore ?? 0),
        ),
        const SizedBox(height: 20),
        Text(
            "Resting Heart Rate: ${recoveryData?.restingHeartRate.toStringAsFixed(1)} bpm"),
        Text("HRV RMSSD: ${recoveryData?.hrvRmssdMilli.toStringAsFixed(1)} ms"),
        Text(
          "SpO2 Percentage: ${recoveryData?.spo2Percentage.toStringAsFixed(1)}%",
        ),
        Text(
          "Skin Temperature: ${recoveryData?.skinTempCelsius.toStringAsFixed(1)}°C",
        ),
      ],
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 67) {
      return Colors.green;
    } else if (score >= 33) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
