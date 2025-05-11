import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Creating a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Late init to store the instance of the [FlutterLocalNotificationsPlugin]
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Boolean to check whether flutter local notification is initialized or not
bool isFlutterLocalNotificationsInitialized = false;

/// Method to setup the flutter notification services
/// It will initialize the [FlutterLocalNotificationsPlugin]
/// and the [AndroidNotificationChannel]
Future<void> setupFlutterLocalNotifications() async {
  /// If already initialized then return from here
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  /// Initializing the flutter Local Notifications Plugin
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Creating the Android Notification Channel
  channel = const AndroidNotificationChannel(
    'naxa_flutter_starter_template_default_notification_id',
    'Default Notification Channel',
    description: 'This channel is used for default notifications',
    importance: Importance.max,
  );

  /// Create an Android Notification Channel.
  /// This channel will be used in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Updating the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /// Initializing the flutterLocalNotification
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification_icon"),
      // Make this false since we are requesting permission on the main wrapper
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      )
    ),
  );

  /// Finally, setting the value of the [isFlutterLocalNotificationsInitialized]
  /// to true
  isFlutterLocalNotificationsInitialized = true;
}

/// Method to show the notification
void showFirebaseNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = notification?.android;
  AppleNotification? apple = notification?.apple;
  if (notification != null && (android != null || apple != null) && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'notification_icon',
          visibility: NotificationVisibility.public,
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
    );
  }
}
