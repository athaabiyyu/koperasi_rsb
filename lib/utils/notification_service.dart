import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Android initialization
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(initSettings);

    // Request notification permission (Android 13+ & iOS)
    await _requestPermissions();

    // Create Android channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'purchase_channel',
      'Pembelian Token',
      description: 'Notifikasi untuk pembelian token berhasil',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Android 13 (API 33) requires POST_NOTIFICATIONS permission
        if (await Permission.notification.isDenied) {
          await Permission.notification.request();
        }
      } else if (Platform.isIOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Notification permission request error: $e');
      }
    }
  }

  Future<void> showPurchaseSuccess({
    required int jumlahToken,
    required String projectId,
  }) async {
    if (!_initialized) return;
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Pembelian token berhasil',
      'Anda membeli $jumlahToken token untuk proyek #$projectId',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'purchase_channel',
          'Pembelian Token',
          channelDescription: 'Notifikasi untuk pembelian token berhasil',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
