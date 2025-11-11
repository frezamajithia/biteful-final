import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart'; // ✅ ADD THIS

class Notify {
  static final Notify instance = Notify._();
  Notify._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    // ✅ Request notification permission
    await Permission.notification.request();
    
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap if needed
      },
    );

    // ✅ Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'biteful_channel',
      'Biteful Notifications',
      description: 'Notifications for Biteful app',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> show({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const android = AndroidNotificationDetails(
      'biteful_channel',
      'Biteful Notifications',
      channelDescription: 'Notifications for Biteful app',
      importance: Importance.max, // ✅ Changed from high to max
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(android: android, iOS: ios);
    
    await _plugin.show(id, title, body, details);
  }

  Future<void> schedule({
    required String title,
    required String body,
    required DateTime when,
  }) async {
    const android = AndroidNotificationDetails(
      'biteful_channel',
      'Biteful Notifications',
      channelDescription: 'Notifications for Biteful app',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _plugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
