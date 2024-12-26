import 'package:flutter/material.dart';
import '../../ui/common/shimmer.dart';
import '../../utils/extension_functions.dart';

import '../../core/styles/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? leading;
  final IconData? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Color? onButtonColor;
  final NaxaAppButtonType buttonType;
  final bool loading;
  final bool uppercase;
  final bool showAlsoLoadingIndicator;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.leading,
    this.trailing,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.color,
    this.onButtonColor,
    this.buttonType = NaxaAppButtonType.elevated,
    this.loading = false,
    this.uppercase = true,
    this.showAlsoLoadingIndicator = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8.0);

    final _color = color ?? context.theme.primaryColor;

    return Padding(
      padding: margin,
      child: Material(
        borderRadius: borderRadius ?? radius,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: borderRadius ?? radius,
          child: Ink(
            width: width,
            height: height,
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: leading != null || trailing != null ? 12.0 : 16.0,
                ),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? radius,
              color: buttonType == NaxaAppButtonType.elevated ? _color : null,
              border: buttonType == NaxaAppButtonType.outlined ||
                      buttonType == NaxaAppButtonType.elevated
                  ? Border.all(
                      color: _color,
                      width: 1.0,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      leading,
                      color: buttonType == NaxaAppButtonType.outlined ||
                              buttonType == NaxaAppButtonType.text
                          ? _color
                          : onButtonColor ?? AppColors.white,
                    ),
                  ),
                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: loading
                        ? Shimmer(
                            child: Text(
                              uppercase ? text.uppercase : text,
                              style: context.textTheme.labelMedium?.copyWith(
                                color:
                                    buttonType == NaxaAppButtonType.outlined ||
                                            buttonType == NaxaAppButtonType.text
                                        ? _color
                                        : onButtonColor ?? AppColors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(
                            uppercase ? text.uppercase : text,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: buttonType == NaxaAppButtonType.outlined ||
                                      buttonType == NaxaAppButtonType.text
                                  ? _color
                                  : onButtonColor ?? AppColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
                if (trailing != null && !loading)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      trailing,
                      color: buttonType == NaxaAppButtonType.outlined ||
                              buttonType == NaxaAppButtonType.text
                          ? _color
                          : onButtonColor ?? AppColors.white,
                    ),
                  ),
                if (loading && showAlsoLoadingIndicator)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(_color),
                        backgroundColor:
                            buttonType == NaxaAppButtonType.elevated
                                ? onButtonColor ?? AppColors.white
                                : null,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enum
enum NaxaAppButtonType {
  elevated,
  text,
  outlined,
}
