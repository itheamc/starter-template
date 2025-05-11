import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template/utils/extension_functions.dart';

import 'app_button.dart';
import 'common_icon.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    super.key,
    required this.info,
    this.buttonText,
    this.onButtonClick,
  });

  final String info;
  final String? buttonText;
  final VoidCallback? onButtonClick;

  /// Method to show dialog
  ///
  static Future<T?> show<T>(
    BuildContext context, {
    required String info,
    String? buttonText,
    VoidCallback? onButtonClick,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      useRootNavigator: true,
      barrierColor: context.theme.dividerColor.withValues(alpha: 0.15),
      builder: (_) {
        return InfoDialog(
          info: info,
          buttonText: buttonText,
          onButtonClick: onButtonClick,
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonIcon(
              icon: Icons.info_outline,
              size: 24.0,
              color: context.theme.colorScheme.primary,
            ),
            SizedBox(height: 20),
            Text(
              info,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(height: 30),
            AppButton(
              onPressed: () {
                context.pop();
                onButtonClick?.call();
              },
              height: 36.0,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.symmetric(horizontal: 36.0),
              text: buttonText ?? 'close',
              buttonType: AppButtonType.outlined,
              uppercase: false,
            ),
          ],
        ),
      ),
    );
  }
}
