import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterLocalNotification {
  // 싱글톤 패턴을 사용하기 위한 private static 변수
  static final FlutterLocalNotification _instance = FlutterLocalNotification._();
  // NotificationService 인스턴스 반환
  factory FlutterLocalNotification() {
    return _instance;
  }
  FlutterLocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
    const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }

  static Future<void> showNotification() async {
    // var scheduleNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 1));


    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        // playSound: true,
        importance: Importance.max,
        priority: Priority.max,
        showWhen: false
    );

    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0,
        'test title',
        'test body',
        // scheduleNotificationDateTime,
        notificationDetails);
  }
}