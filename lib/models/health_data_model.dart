class HealthDataDay {
  final String date;
  final HealthData healthData;

  HealthDataDay({
    required this.date,
    required this.healthData,
  });

  factory HealthDataDay.fromJson(Map<String, dynamic> json) {
    return HealthDataDay(
      date: json['date'],
      healthData: HealthData.fromJson(json['healthData']),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'healthData': healthData.toJson(),
      };
}

class HealthData {
  final int distance;
  final int steps;
  final int maxHeartRate;
  final int minHeartRate;

  HealthData({
    required this.distance,
    required this.steps,
    required this.maxHeartRate,
    required this.minHeartRate,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      distance: json['distance'],
      steps: json['steps'],
      maxHeartRate: json['max_heart_rate'],
      minHeartRate: json['min_heart_rate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'steps': steps,
        'max_heart_rate': maxHeartRate,
        'min_heart_rate': minHeartRate,
      };
}
