import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env/env.dart';
import 'core/config/flavor/flavor.dart';
import 'core/config/flavor/configuration_provider.dart';
import 'core/config/flavor/configuration.dart';
import 'core/services/firebase/firebase_notification/fcm_notification_service.dart';
import 'core/services/storage/hive_storage_service.dart';
import 'core/services/storage/storage_service_provider.dart';
import 'utils/logger.dart';
import 'starter_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensuring widgets flutter binding initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing and loading data from .env
  await Env.instance.load();

  // Firebase app and local notification initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Setup and initialize location notification
    if (!kIsWeb) {
      await setupFlutterLocalNotifications();
    }

    // Adding listener for onBackgroundMessage callback
    // (background & terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    // Error Initializing Firebase App
    Logger.logError("[main -> initializeApp] ---> $e");
  }

  // Flavor configuration
  final configuration = Configuration.of(Flavor.fromEnvironment);

  // Hive-specific initialization
  final storageService = HiveStorageService.instance;
  await storageService.init(configuration.hiveBoxName);

  runApp(
    ConfigurationProvider(
      configuration: configuration,
      child: ProviderScope(
        overrides: [
          flavorConfigurationProvider.overrideWithValue(configuration),
          storageServiceProvider.overrideWithValue(storageService),
        ],
        child: const StarterApp(),
      ),
    ),
  );
}

/// Method to handle the background notification handling and display
///
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb) {
      await setupFlutterLocalNotifications();
    }
    // showFirebaseNotification(message);
  } catch (e) {
    Logger.logError("[main -> _firebaseMessagingBackgroundHandler] ---> $e");
  }
}
