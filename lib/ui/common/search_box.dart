import 'package:flutter/material.dart';
import 'package:starter_template/core/styles/app_theme.dart';
import '../../../../../utils/extension_functions.dart';
import '../../core/styles/app_colors.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    this.hint = 'Search',
    this.controller,
    this.margin = EdgeInsets.zero,
    this.enabled = true,
    this.required = false,
    this.maxLength,
    this.readOnly = false,
    this.filled = false,
    this.fillColor,
    this.borderColor,
    this.showClearButton = false,
    this.onChanged,
    this.onSearched,
    this.onCleared,
  });

  final String hint;
  final TextEditingController? controller;
  final EdgeInsetsGeometry margin;
  final bool enabled;
  final bool required;
  final int? maxLength;
  final bool readOnly;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final bool showClearButton;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSearched;
  final VoidCallback? onCleared;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  /// Search Controller to use if not provided
  ///
  final _controller = TextEditingController();

  /// Notifier to show clear button
  ///
  late ValueNotifier<bool> _showClear;

  @override
  void initState() {
    super.initState();
    _showClear = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: TextFormField(
        controller: widget.controller ?? _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: context.textTheme.regular14?.copyWith(
            color: context.theme.hintColor,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: _showClear,
            builder: (context, show, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 275),
                child: show
                    ? IconButton(
                        onPressed: () {
                          (widget.controller ?? _controller).clear();
                          _showClear.value = false;
                          widget.onCleared?.call();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : SizedBox.shrink(),
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.grey,
            ),
          ),
          filled: widget.filled,
          fillColor: widget.fillColor,
          isDense: true,
        ),
        textAlignVertical: TextAlignVertical.center,
        style: context.textTheme.regular14?.copyWith(
          color: !widget.enabled ? context.theme.hintColor : null,
        ),
        onChanged: (s) {
          _showClear.value = widget.showClearButton && s.trim().isNotEmpty;
          widget.onChanged?.call(s);
        },
        onFieldSubmitted: widget.onSearched,
        keyboardType: TextInputType.text,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        buildCounter: (
          _, {
          required int currentLength,
          required bool isFocused,
          int? maxLength,
        }) =>
            null,
        maxLines: 1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _showClear.dispose();
    super.dispose();
  }
}
