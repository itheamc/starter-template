import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/extension_functions.dart';

class ImagePickerSourceSelectionBottomSheet extends StatefulWidget {
  final VoidCallback? onGalleryPick;
  final VoidCallback? onCameraPick;
  final EdgeInsetsGeometry margin;
  final bool showDragLine;

  const ImagePickerSourceSelectionBottomSheet({
    super.key,
    this.onGalleryPick,
    this.onCameraPick,
    this.margin = EdgeInsets.zero,
    this.showDragLine = false,
  });

  /// Method to show bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    VoidCallback? onGalleryPick,
    VoidCallback? onCameraPick,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool showDragLine = false,
  }) {
    return context.showBottomSheet<T>(
        builder: (BuildContext context) {
          return ImagePickerSourceSelectionBottomSheet(
            onCameraPick: onCameraPick,
            onGalleryPick: onGalleryPick,
            margin: margin,
            showDragLine: showDragLine,
          );
        },
        useRootNavigator: true,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder());
  }

  @override
  State<ImagePickerSourceSelectionBottomSheet> createState() =>
      _ImagePickerSourceSelectionBottomSheetState();
}

class _ImagePickerSourceSelectionBottomSheetState
    extends State<ImagePickerSourceSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding:
              widget.showDragLine ? EdgeInsets.zero : const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showDragLine)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 55.0,
                      height: 7.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: context.theme.dividerColor,
                      ),
                    ),
                  ),
                ),
              _ui4Item(
                icon: Icons.camera_enhance_outlined,
                label: context.appLocalization.camera,
                onClick: widget.onCameraPick,
              ),
              _ui4Item(
                icon: Icons.image_outlined,
                label: context.appLocalization.gallery,
                onClick: widget.onGalleryPick,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ui for item
  Widget _ui4Item({
    required IconData? icon,
    required String label,
    VoidCallback? onClick,
  }) {
    return InkWell(
      onTap: () {
        context.pop();
        Future.delayed(const Duration(milliseconds: 225), onClick);
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Text(
                label,
                style: context.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
