import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template/core/styles/app_theme.dart';
import 'package:starter_template/utils/extension_functions.dart';

import 'app_button.dart';
import 'common_icon.dart';

class CustomWarningDialog extends StatelessWidget {
  const CustomWarningDialog({
    super.key,
    required this.title,
    this.description,
    this.buttonText,
    this.cancelButtonText,
    this.icon,
    this.titleStyle,
    this.descriptionStyle,
    this.onPressed,
    this.onCancel,
    this.showIcon = true,
  });

  final String title;
  final String? description;
  final String? buttonText;
  final String? cancelButtonText;
  final dynamic icon;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final VoidCallback? onPressed;
  final VoidCallback? onCancel;
  final bool showIcon;

  /// Method to show dialog
  ///
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? description,
    String? buttonText,
    String? cancelButtonText,
    dynamic icon,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    VoidCallback? onPressed,
    VoidCallback? onCancel,
    bool showIcon = true,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      useRootNavigator: true,
      barrierColor: context.theme.dividerColor.withValues(alpha: 0.15),
      builder: (_) {
        return CustomWarningDialog(
          title: title,
          description: description,
          buttonText: buttonText,
          cancelButtonText: cancelButtonText,
          icon: icon,
          titleStyle: titleStyle,
          descriptionStyle: descriptionStyle,
          onPressed: onPressed,
          onCancel: onCancel,
          showIcon: showIcon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: context.theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              CommonIcon(
                icon: icon ?? Icons.warning_amber,
                size: 24.0,
                color: context.theme.colorScheme.error,
              ),
            SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? context.textTheme.semibold14,
            ),
            if (description != null && description!.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                description ?? '',
                textAlign: TextAlign.center,
                style: descriptionStyle ?? context.textTheme.regular12,
              ),
            ],
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 12.0,
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        if (context.canPop()) context.pop();
                        onCancel?.call();
                      },
                      height: 36.0,
                      padding: EdgeInsets.zero,
                      text: cancelButtonText ?? context.appLocalization.cancel,
                      buttonType: AppButtonType.outlined,
                      uppercase: false,
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        if (context.canPop()) context.pop();
                        onPressed?.call();
                      },
                      height: 36.0,
                      padding: EdgeInsets.zero,
                      text: buttonText ?? 'confirm',
                      buttonType: AppButtonType.elevated,
                      uppercase: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
