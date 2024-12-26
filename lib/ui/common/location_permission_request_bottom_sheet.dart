import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/extension_functions.dart';
import '../../ui/common/app_button.dart';

class LocationPermissionRequestBottomSheet extends StatefulWidget {
  final VoidCallback? onAllowClick;
  final VoidCallback? onCancelClick;

  const LocationPermissionRequestBottomSheet({
    super.key,
    this.onAllowClick,
    this.onCancelClick,
  });

  /// Method to show bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    VoidCallback? onAllowClick,
    VoidCallback? onCancelClick,
  }) {
    return context.showBottomSheet<T>(
      builder: (BuildContext context) {
        return LocationPermissionRequestBottomSheet(
          onAllowClick: onAllowClick,
          onCancelClick: onCancelClick,
        );
      },
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      useRootNavigator: true,
      isScrollControlled: false,
      isDismissible: false,
    );
  }

  @override
  State<LocationPermissionRequestBottomSheet> createState() =>
      _LocationPermissionRequestBottomSheetState();
}

class _LocationPermissionRequestBottomSheetState
    extends State<LocationPermissionRequestBottomSheet> {
  // Flag to handle the dismissed by back button
  bool _isAlreadyDismissed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.appLocalization.location_service_dialog_title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.appLocalization.location_service_dialog_body,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.75,
                ),
              ),
            ),
            AppButton(
              text: context.appLocalization.allow,
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              onPressed: () {
                _isAlreadyDismissed = true;

                context.pop();
                Future.delayed(const Duration(milliseconds: 375), () {
                  widget.onAllowClick?.call();
                });
              },
            ),
            AppButton(
              text: context.appLocalization.cancel,
              margin: const EdgeInsets.all(16.0),
              buttonType: NaxaAppButtonType.text,
              onPressed: () {
                _isAlreadyDismissed = true;

                context.pop();
                Future.delayed(const Duration(milliseconds: 375), () {
                  widget.onCancelClick?.call();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    if (!_isAlreadyDismissed) {
      widget.onCancelClick?.call();
    }
    super.deactivate();
  }
}
