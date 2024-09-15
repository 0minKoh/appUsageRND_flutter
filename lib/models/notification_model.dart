class NotificationDay {
  final String date;
  final List<Notification> notifications;

  NotificationDay({
    required this.date,
    required this.notifications,
  });

  factory NotificationDay.fromJson(Map<String, dynamic> json) {
    return NotificationDay(
      date: json['date'],
      notifications: (json['notifications'] as List)
          .map((data) => Notification.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'notifications': notifications.map((data) => data.toJson()).toList(),
      };
}

class Notification {
  final String appBundleId;
  final int duration;
  final String timestamp;

  Notification({
    required this.appBundleId,
    required this.duration,
    required this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      appBundleId: json['app_bundle_id'],
      duration: json['duration'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'app_bundle_id': appBundleId,
        'duration': duration,
        'timestamp': timestamp,
      };
}
