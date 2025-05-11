import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../ui/common/custom_expansion_builder.dart';
import 'logger.dart';
import '../ui/common/app_button.dart';
import '../ui/common/gradient_mask.dart';
import 'extension_functions.dart';

class IosUpdater {
  static Future<void> check4Update(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final bundleId = packageInfo.packageName;

      final url =
          Uri.parse('https://itunes.apple.com/lookup?bundleId=$bundleId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final results = decodedJson['results'];

        // If results is not a list or is empty return from here
        if (results is! List || results.isEmpty) return;

        // Getting app info
        final appInfo = results.first;

        // Getting the latest version available in app store
        final latestVersion = appInfo['version'];

        // Checking if update is available
        if (_isUpdateAvailable(currentVersion, latestVersion)) {
          // Showing update dialog
          if (context.mounted) _showUpdateSheet(context, appInfo);
        }
      }
    } catch (e) {
      Logger.logError(e.toString());
    }
  }

  /// Method to check if update is available or not
  /// by comparing the current and latest version
  ///
  static bool _isUpdateAvailable(String currentVersion, String latestVersion) {
    Logger.logMessage("Current Version: $currentVersion");
    Logger.logMessage("Latest Version: $latestVersion");
    return latestVersion.compareTo(currentVersion) > 0;
  }

  /// Method to show update dialog if update is available
  ///
  static Future<T?> _showUpdateDialog<T>(
    BuildContext context,
    dynamic appInfo,
  ) async {
    final appStoreUrl = appInfo['trackViewUrl']?.toString();

    if (appStoreUrl == null) return null;

    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.update,
                      size: 100.0,
                      color: context.theme.primaryColor,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      context.appLocalization.update_available,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        context.appLocalization.update_available_desc,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    AppButton(
                      width: context.width * 0.4,
                      borderRadius: BorderRadius.circular(24.0),
                      onPressed: () async {
                        if (await canLaunchUrlString(appStoreUrl)) {
                          await launchUrlString(appStoreUrl);
                        }
                      },
                      text: context.appLocalization.update_now,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.mediaQuery.padding.top,
                      right: 16.0,
                    ),
                    child: IconButton(
                      onPressed: context.pop,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Method to show update sheet if update is available
  ///
  static Future<T?> _showUpdateSheet<T>(
    BuildContext context,
    dynamic appInfo,
  ) async {
    // Getting app store link
    final appStoreUrl = appInfo['trackViewUrl']?.toString();

    // If link is null return from here
    if (appStoreUrl == null) return null;

    // app icon
    final appIcon = appInfo['artworkUrl60']?.toString();

    // app name
    final appName = appInfo['trackName']?.toString();

    // version
    final appVersion = appInfo['version']?.toString();

    // release notes
    final releaseNotes = appInfo['releaseNotes']?.toString();

    // release date
    final updatedDate = appInfo['currentVersionReleaseDate']?.toString();

    // file size
    final appSizeStr = appInfo['fileSizeBytes']?.toString();
    double? appSize = double.tryParse(appSizeStr ?? '1');
    appSize =
        double.tryParse(((appSize ?? 1) / (1024 * 1024)).toStringAsFixed(2));

    return showModalBottomSheet<T>(
      context: context,
      barrierColor: context.isDarkTheme ? Colors.white12 : Colors.black26,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: context.mediaQuery.padding.bottom,
          ),
          child: Material(
            shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.vertical(
              //   top: Radius.circular(20.0),
              // ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 8.0,
                    top: 20.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        'https://www.apple.com/v/app-store/b/images/overview/icon_appstore__ev0z770zyxoy_large_2x.png',
                        // Replace with your Google Play logo path
                        width: 22.0,
                        height: 22.0,
                      ),
                      const SizedBox(width: 8),
                      GradientMask(
                        colors: const [
                          Color(0xff1a74f3),
                          Color(0xff1a74f3),
                          Color(0xff1a74f3),
                          Color(0xff11bffb),
                        ],
                        child: Text(
                          context.appLocalization.app_store,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                context.theme.iconTheme.color?.withValues(alpha: 0.7),
                          ),
                          textScaler: const TextScaler.linear(0.9),
                        ),
                      ),
                      // const Spacer(),
                      // IconButton(
                      //   onPressed: context.pop,
                      //   icon: const Icon(
                      //     Icons.close,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.appLocalization.update_available,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkTheme
                                ? Colors.white
                                : Colors.black87,
                          ),
                          textScaler: const TextScaler.linear(0.85),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          context.appLocalization.update_available_desc,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.isDarkTheme
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                appIcon ?? '',
                                // Replace with your app icon path
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appName ?? '',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.textTheme.titleMedium?.color
                                        ?.withValues(alpha: 0.8),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'v',
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                          color: context
                                              .textTheme.labelLarge?.color
                                              ?.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: appVersion,
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                          color: context
                                              .textTheme.labelLarge?.color
                                              ?.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  |  ',
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                          color: context
                                              .textTheme.labelLarge?.color
                                              ?.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '$appSize MB',
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                          color: context
                                              .textTheme.labelLarge?.color
                                              ?.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Flexible(
                          child: CustomExpansionBuilder(
                            initiallyExpanded: false,
                            builder: (_, animation, expanded, onToggle) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      context.appLocalization.whats_new,
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.isDarkTheme
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                      textScaler: const TextScaler.linear(0.85),
                                    ),
                                    subtitle: Text(
                                        '${context.appLocalization.updated_on} ${updatedDate?.toddMMMYYYY}'),
                                    trailing: IconButton(
                                      onPressed: onToggle,
                                      splashRadius: 24.0,
                                      padding: EdgeInsets.zero,
                                      icon: RotatedBox(
                                        quarterTurns: expanded ? 2 : 0,
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: SizeTransition(
                                      sizeFactor: animation,
                                      axisAlignment: -1.0,
                                      child: Text(
                                        releaseNotes ?? '',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                  buttonType: AppButtonType.outlined,
                                  onPressed: context.pop,
                                  text: context.appLocalization.update_later,
                                  color: context.isDarkTheme
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: AppButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                  onPressed: () async {
                                    if (await canLaunchUrlString(appStoreUrl)) {
                                      await launchUrlString(appStoreUrl);
                                    }
                                  },
                                  text: context.appLocalization.update_now,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
