import 'package:flutter/material.dart';
import 'package:starter_template/utils/extension_functions.dart';

class MapControlRoundedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onClick;
  final EdgeInsetsGeometry margin;

  const MapControlRoundedIconButton({
    super.key,
    required this.icon,
    this.onClick,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        elevation: 10.0,
        shadowColor: context.theme.dividerColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(48.0),
        color: onClick == null
            ? context.theme.colorScheme.onSurface.withValues(alpha: 0.05)
            : context.theme.colorScheme.surface,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(48.0),
          child: Ink(
            height: 48.0,
            width: 48.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
