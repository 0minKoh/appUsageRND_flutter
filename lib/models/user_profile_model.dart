import 'package:app_usage_rnd_android/models/app_usage_model.dart';
import 'package:app_usage_rnd_android/models/health_data_model.dart';
import 'package:app_usage_rnd_android/models/notification_model.dart';

class UserProfile {
  final String id;
  final String email;
  final int age;
  final String gender;
  final String device;
  final List<AppUsageDay> appUsage;
  final List<NotificationDay> notifications;
  final List<HealthDataDay> healthData;

  UserProfile({
    required this.id,
    required this.email,
    required this.age,
    required this.gender,
    required this.device,
    required this.appUsage,
    required this.notifications,
    required this.healthData,
  });

  // JSON to Model
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      device: json['device'],
      appUsage: (json['app_usage'] as List)
          .map((data) => AppUsageDay.fromJson(data))
          .toList(),
      notifications: (json['notifications'] as List)
          .map((data) => NotificationDay.fromJson(data))
          .toList(),
      healthData: (json['health_data'] as List)
          .map((data) => HealthDataDay.fromJson(data))
          .toList(),
    );
  }

  // Model to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'age': age,
        'gender': gender,
        'device': device,
        'app_usage': appUsage.map((data) => data.toJson()).toList(),
        'notifications': notifications.map((data) => data.toJson()).toList(),
        'health_data': healthData.map((data) => data.toJson()).toList(),
      };
}
