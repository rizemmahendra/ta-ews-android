import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _notificationChannelId = 'alert_notification';
  static const String _notificationChannelName = 'Alert Notification';
  static const String _notificationChannelDescription =
      'Notification Channel for Alert';

  static const String _notificationChannelGroupId = 'early_warning_system';
  static const String _notificationChannelGroupName = 'Early Warning System';

  static int _notificationId = 0;

  int get id => _notificationId;

  static Future<void> initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const iOsInitialize = DarwinInitializationSettings();

    const initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOsInitialize);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannelGroup notificationChannelGroup =
        AndroidNotificationChannelGroup(
            _notificationChannelGroupId, _notificationChannelGroupName);

    const AndroidNotificationChannel notificationChannel =
        AndroidNotificationChannel(
            _notificationChannelId, _notificationChannelName,
            description: _notificationChannelDescription,
            enableVibration: true,
            groupId: _notificationChannelGroupId,
            playSound: true,
            showBadge: true,
            enableLights: true,
            importance: Importance.max);

    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid) {
      if (androidInfo.version.sdkInt >= 26 /* Android 8.0 or newer */) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannelGroup(notificationChannelGroup);
        log('Create/Update Notification Group Channel');

        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(notificationChannel);
      }
      if (androidInfo.version.sdkInt >= 33 /* Android 13.0 */) {
        var requestExactAlarmsPermission =
            await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestExactAlarmsPermission();
        if (requestExactAlarmsPermission =
            true && requestExactAlarmsPermission != null) {
          log("Exact Alarm Permission Access Granted");
        }
        var requestNotificationsPermission =
            await _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission();
        if (requestNotificationsPermission =
            true && requestNotificationsPermission != null) {
          log("Notification Permission Access Granted");
        }
      }
    }
    log("Notification Service Successful Initialize");
  }

  static Future<void> showNotification(
      {String? title, String? body, String? payload}) async {
    log('id notif : $_notificationId');
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            _notificationChannelId, _notificationChannelName,
            channelShowBadge: true,
            enableVibration: true,
            playSound: true,
            groupKey: _notificationChannelGroupId,
            importance: Importance.max,
            // fullScreenIntent: true,
            priority: Priority.max,
            styleInformation: BigTextStyleInformation(''));

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentAlert: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        _notificationId, title, body, notificationDetails,
        payload: payload);
    _notificationId++;
  }
}
