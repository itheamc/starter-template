import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utils/extension_functions.dart';
import '../../../../../utils/field_validator.dart';
import '../../../../common/app_button.dart';
import '../../provider/forgot_password_request_state_provider.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  /// Forgot Password form key
  ///
  final _formKey = GlobalKey<FormState>();

  /// Text Controllers
  ///
  final _emailOrPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final forgotPasswordRequestState =
        ref.watch(forgotPasswordRequestStateProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment:
                    context.isRtl ? Alignment.topRight : Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.isRtl ? 0.0 : 12.0,
                    right: context.isRtl ? 12.0 : 0.0,
                    top: context.padding.top,
                  ),
                  child: IconButton(
                    onPressed: context.pop,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: context.height * 0.25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.appLocalization.forgot_password,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        context.appLocalization.email_or_phone_label,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthTextField(
                      controller: _emailOrPhoneController,
                      label: context.appLocalization.email_or_phone,
                      hint: context.appLocalization.email_or_phone_hint,
                      margin: EdgeInsets.fromLTRB(
                        16.0,
                        context.height * 0.0375,
                        16.0,
                        16.0,
                      ),
                      inputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FieldValidator.validateEmailOrPhone(
                          value,
                          context: context,
                        );
                      },
                      enabled: !forgotPasswordRequestState.requesting,
                    ),
                  ],
                ),
              ),
              AppButton(
                onPressed: _handleForgotPasswordButtonPressed,
                text: context.appLocalization.next,
                margin: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 40.0,
                  bottom: 16.0,
                ),
                loading: forgotPasswordRequestState.requesting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method to handle forgot password button pressed
  ///
  Future<void> _handleForgotPasswordButtonPressed() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() == true) {
      // Checking if entered value is phone
      final isPhone = FieldValidator.validateMobile(
              _emailOrPhoneController.text.trim(),
              context: context) ==
          null;

      final payloads = <String, dynamic>{};

      payloads[isPhone ? 'phone' : 'email'] =
          _emailOrPhoneController.text.trim();

      await ref
          .read(forgotPasswordRequestStateProvider.notifier)
          .forgotPassword(
            payloads: payloads,
            onCompleted: (success) {
              if (mounted && success) {
                context.pop();
              }
            },
          );
    }
  }

  /// Dispose
  ///
  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    super.dispose();
  }
}
