import 'package:flutter/material.dart';
import '../../../../../utils/extension_functions.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.margin = EdgeInsets.zero,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.inputType,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.required = false,
    this.maxLength,
    this.readOnly = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final EdgeInsetsGeometry margin;
  final TextInputAction textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final void Function(String?)? onSaved;
  final TextInputType? inputType;
  final AutovalidateMode autoValidateMode;
  final bool enabled;
  final bool required;
  final int? maxLength;
  final bool readOnly;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  /// ObscureText
  ///
  bool? _obscure;

  /// Init State
  ///
  @override
  void initState() {
    super.initState();
  }

  /// Toggle Obscure
  ///
  void _toggleObscure() {
    if (widget.obscureText) {
      setState(() {
        _obscure = !(_obscure ?? widget.obscureText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.required)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.label,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: !widget.enabled ? context.theme.hintColor : null,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '*',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: !widget.enabled
                          ? context.theme.hintColor
                          : context.theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              widget.label,
              style: context.textTheme.bodySmall?.copyWith(
                color: !widget.enabled ? context.theme.hintColor : null,
              ),
            ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: widget.controller,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              hintText: widget.hint ?? widget.label,
              hintStyle: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.hintColor,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              isDense: true,
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      onTap: _toggleObscure,
                      child: Icon(
                        (_obscure ?? widget.obscureText)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 24.0,
                      ),
                    )
                  : null,
            ),
            obscureText:
                widget.obscureText ? _obscure ?? widget.obscureText : false,
            textAlignVertical: TextAlignVertical.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: !widget.enabled ? context.theme.hintColor : null,
            ),
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onSaved: widget.onSaved,
            keyboardType: widget.inputType,
            autovalidateMode: widget.autoValidateMode,
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
          ),
        ],
      ),
    );
  }
}
