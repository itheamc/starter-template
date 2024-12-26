import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../utils/logger.dart';

import 'fcm_notification_service.dart';

class FCMNotificationHandler {
  /// Method to init the Firebase messaging
  static Future<void> initialize({
    void Function(String)? onTokenRefreshed,
    void Function(RemoteMessage)? onMessageOpenedApp,
    void Function(RemoteMessage)? onMessage,
  }) async {
    try {
      // FirebaseMessaging instance
      final messaging = FirebaseMessaging.instance;

      /// Handling firebase token
      // Get the token each time the application loads
      String? token = await messaging.getToken();

      // Calling on token refreshed callback
      if (token != null) {
        Logger.logMessage(token);
        onTokenRefreshed?.call(token);
      }

      // Adding listener to listen token refresh
      // Any time the token refreshes, store this in the database too.
      messaging.onTokenRefresh.listen(onTokenRefreshed);

      /// Getting the initial firebase message if any
      // Get any messages which caused the application to open from
      // a terminated state.
      RemoteMessage? initialMessage = await messaging.getInitialMessage();

      // If initialize message in not null
      if (initialMessage != null) {
        // showFirebaseNotification(initialMessage);
        onMessageOpenedApp?.call(initialMessage);
      }

      /// Subscribe to topics
      // await FirebaseMessaging.instance.subscribeToTopic("announcement");
      // await FirebaseMessaging.instance.subscribeToTopic("comment");

      /// Adding callback function to listen the firebase notification(foreground state)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showFirebaseNotification(message);
        onMessage?.call(message);
      });

      /// Adding callback for onMessageOpened
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    } catch (e) {
      Logger.logError(
          "=======[FCMNotificationHandler.initialize]=======>$e");
    }
  }

  /// Static method to request permission
  static Future<bool> requestPermission() async {
    try {
      // Request permission
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        criticalAlert: true,
        announcement: true,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      Logger.logError(
          "=======[FCMNotificationHandler.requestPermission]=======>$e");
    }

    return false;
  }
}
