import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template/core/services/location/location_service.dart';

import '../../../../../core/services/firebase/firebase_notification/fcm_notification_handler.dart';
import '../../../../../ui/features/notifications/provider/fcm_device_add_or_update_request_state_provider.dart';
import '../../../../../core/services/connectivity/connectivity_status_provider.dart';
import '../../../../../core/services/location/current_location_provider.dart';
import '../../../../../ui/features/main_wrapper/views/widgets/naxa_bottom_navigation.dart';
import '../../../../../core/services/location/location_service_status_provider.dart';
import '../../../../../ui/common/location_permission_request_bottom_sheet.dart';
import '../../enums/nav_item.dart';
import '../../../../../utils/extension_functions.dart';
import '../../../../../utils/android_in_app_updater.dart';
import '../../../../../utils/ios_updater.dart';

class MainWrapperScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell shell;
  final GoRouterState state;

  const MainWrapperScreen({
    super.key,
    required this.shell,
    required this.state,
  });

  @override
  ConsumerState<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends ConsumerState<MainWrapperScreen> {
  /// For controlling the visibility of bottom navigation and app bar
  ///
  bool get _showNavBar => NavItem.values.map((e) => e.path).any(
        (p) => context.goRouter.routeInformationProvider.value.uri.path
            .startsWith(p),
      );

  /// For controlling the visibility app bar
  ///
  // bool get _showAppBar {
  //   // getting the paths of navigation items excluding the "profile" & "map"
  //   final paths = NavItem.values
  //       .where((item) => (item != NavItem.profile && item != NavItem.map))
  //       .map((e) => e.path);
  //
  //   // Checking if the current route's path matches any of the remaining paths
  //   return paths
  //       .contains(context.goRouter.routeInformationProvider.value.uri.path);
  // }

  /// Init State
  ///
  @override
  void initState() {
    super.initState();

    // Kept initialize firebase notification service on location service
    // request completion to show permission request dialog one by one
    // if not granted
    _checkAndShowLocationServiceRequestDialogIfNotAllowed(
      onCompletion: () {
        _initializeFirebaseNotificationService();
      },
    );

    // Checking for update availability
    Future.delayed(const Duration(milliseconds: 500), _check4AppUpdate);
  }

  /// Method to check and show location service request dialog
  /// if not already enabled/allowed
  ///
  Future<void> _checkAndShowLocationServiceRequestDialogIfNotAllowed({
    VoidCallback? onCompletion,
  }) async {
    await ref
        .read(locationServiceStatusStateProvider.notifier)
        .checkLocationServiceStatus(
      onCompleted: (allowed) {
        if (!allowed) {
          LocationPermissionRequestBottomSheet.show(
            context,
            onAllowClick: () {
              LocationService.instance.checkAndRequestLocationPermission(
                retries: 2,
                onCompleted: (granted) {
                  // Invoking Completion
                  onCompletion?.call();

                  // if permission is not granted
                  if (!granted || !mounted) return;

                  // Subscribe to location update
                  _subscribeToLocationUpdate();
                },
              );
            },
            onCancelClick: onCompletion,
          );
          return;
        }

        // Invoking Completion
        onCompletion?.call();

        // Subscribe to location update
        _subscribeToLocationUpdate();
      },
    );
  }

  /// Method to subscribe to location change/ update
  ///
  void _subscribeToLocationUpdate() {
    if (!mounted) return;
    ref.read(currentLocationProvider.notifier).subscribeLocationUpdate();
  }

  /// Method to set up firebase notification service
  ///
  Future<void> _initializeFirebaseNotificationService() async {
    FCMNotificationHandler.requestPermission().then((granted) {
      // If not granted return
      if (!granted) return;

      // Else initialize
      FCMNotificationHandler.initialize(
        onTokenRefreshed: (token) {
          // Update token to database
          if (mounted) {
            final connected = ref.read(connectivityStatusProvider);

            // If internet available
            if (connected) {
              ref
                  .read(fcmDeviceAddOrUpdateRequestStateProvider.notifier)
                  .addOrUpdateFcmDevice(token: token);
            }
          }
        },
        onMessageOpenedApp: (message) {
          // Handle navigation as per the data
        },
      );
    });
  }

  /// Method to check for app update availability on the app store
  ///
  Future<void> _check4AppUpdate() async {
    if (Platform.isAndroid) {
      await AndroidInAppUpdater.check4Update();
      return;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await IosUpdater.check4Update(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: widget.shell,
        bottomNavigationBar: AnimatedSize(
          duration: const Duration(milliseconds: 175),
          child: _showNavBar
              ? NaxaBottomNavigation(
                  items: NavItem.values,
                  currentNavItem: NavItem.values[widget.shell.currentIndex],
                  onSelect: (i, item) {
                    widget.shell.goBranch(i);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
