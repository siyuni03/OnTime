import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(settings: initializationSettings);

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'ontime_channel',
          'OnTime 알림',
          channelDescription: 'OnTime 일정 알림',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id: 0,
      title: 'OnTime',
      body: '알림 기능이 정상적으로 작동합니다.',
      notificationDetails: notificationDetails,
    );
  }

  // 기본 예약 알림
  static Future<void> scheduleNotification({
    required int id,
    required DateTime scheduledDate,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'ontime_schedule_channel',
          'OnTime 일정 알림',
          channelDescription: 'OnTime 일정 알림',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // 일정별 출발 알림 3개 예약
  static Future<void> scheduleDepartureNotifications({
    required int id,
    required DateTime departureTime,
    required String title,
  }) async {
    final notificationMinutes = [10, 5, 0];

    for (int i = 0; i < notificationMinutes.length; i++) {
      final minutes = notificationMinutes[i];

      final notificationTime = departureTime.subtract(
        Duration(minutes: minutes),
      );

      if (!notificationTime.isAfter(DateTime.now())) {
        continue;
      }

      await scheduleNotification(
        id: id * 10 + i,
        scheduledDate: notificationTime,
        title: minutes == 0 ? '지금 출발하세요!' : '출발 준비 알림',
        body: minutes == 0
            ? '$title 출발 시간입니다.'
            : '$title 출발까지 ${minutes}분 남았습니다.',
      );
    }
  }

  // 예약된 알림 취소
  static Future<void> cancelDepartureNotifications(int id) async {
    for (int i = 0; i < 3; i++) {
      await _notifications.cancel(id: id * 10 + i);
    }
  }
}
