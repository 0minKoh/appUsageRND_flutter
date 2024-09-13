class Notification {
  final String packageName;
  final Duration timestamp;
  final Duration duration;

  Notification(
      {required this.packageName,
      required this.timestamp,
      required this.duration});

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'timestamp': timestamp,
        'duration': duration,
      };

  // JSON에서 객체로 변환
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      packageName: json['packageName'],
      timestamp: json['timestamp'],
      duration: json['duration'],
    );
  }
}

class NotificationDay {
  final String date;
  final List<Notification> notificationData;

  NotificationDay({
    required this.date,
    required this.notificationData,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
        date: notificationData.map((data) => data.toJson()).toList(),
      };

  // JSON에서 객체로 변환
  factory NotificationDay.fromJson(String date, Map<String, dynamic> json) {
    var notificationData = (json[date] as List)
        .map((data) => Notification.fromJson(data))
        .toList();
    return NotificationDay(date: date, notificationData: notificationData);
  }
}

class NotificationModel {
  final Map<String, List<NotificationDay>> notifications;

  NotificationModel({
    required this.notifications,
  });

  // 전체 데이터를 JSON으로 변환
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    notifications.forEach((date, notificationDays) {
      json[date] = notificationDays.map((day) => day.toJson()).toList();
    });
    return json;
  }

  // JSON에서 전체 데이터를 객체로 변환
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<NotificationDay>> notifications = {};
    json.forEach((date, data) {
      var notificationDays = (data as List)
          .map((dayJson) => NotificationDay.fromJson(date, dayJson))
          .toList();
      notifications[date] = notificationDays;
    });
    return NotificationModel(notifications: notifications);
  }
}
