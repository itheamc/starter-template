import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/common/circular_icon_button.dart';
import '../../../../../ui/features/auth/provider/apple_login_request_state_provider.dart';
import '../../../../../ui/features/auth/provider/google_login_request_state_provider.dart';
import '../../../../../ui/common/app_button.dart';
import '../../../../../utils/extension_functions.dart';
import '../../../../../core/services/router/app_router.dart';
import '../../../../../utils/field_validator.dart';
import '../../../profile/provider/user_profile_state_provider.dart';
import '../../provider/login_request_state_provider.dart';
import '../../provider/user_logged_in_state_provider.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Login form key
  ///
  final _loginFormKey = GlobalKey<FormState>();

  /// Text Controllers
  ///
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginRequestState = ref.watch(loginRequestStateProvider);
    final googleLoginRequestState = ref.watch(googleLoginRequestStateProvider);
    final appleLoginRequestState = ref.watch(appleLoginRequestStateProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.25,
              ),
              Text(
                context.appLocalization.sign_in,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthTextField(
                      controller: _usernameController,
                      label: context.appLocalization.phone_or_username,
                      hint: context.appLocalization.phone_or_username_hint,
                      margin: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      inputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FieldValidator.validateUsernameOrPhone(value,
                            context: context);
                      },
                      enabled: !loginRequestState.requesting &&
                          !googleLoginRequestState.requesting &&
                          !appleLoginRequestState.requesting,
                    ),
                    AuthTextField(
                      controller: _passwordController,
                      label: context.appLocalization.password,
                      hint: context.appLocalization.password,
                      margin: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        0.0,
                      ),
                      obscureText: true,
                      inputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FieldValidator.validatePassword(value,
                            context: context);
                      },
                      enabled: !loginRequestState.requesting &&
                          !googleLoginRequestState.requesting &&
                          !appleLoginRequestState.requesting,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            if (!loginRequestState.requesting &&
                                !googleLoginRequestState.requesting &&
                                !appleLoginRequestState.requesting) {
                              context.pushNamed(
                                  AppRouter.forgotPassword.toPathName);
                            }
                          },
                          child: Text(
                            context.appLocalization.forgot_password,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.isDarkTheme
                                  ? context.theme.primaryColorLight
                                  : context.theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                onPressed: _handleLoginButtonPressed,
                text: context.appLocalization.sign_in,
                margin: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 36.0,
                  // bottom: 16.0,
                ),
                loading: loginRequestState.requesting,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(context.appLocalization.or),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularIconButton(
                    urlOrName: "assets/svg/google.svg",
                    imageSource: IconImageSource.local,
                    loading: googleLoginRequestState.requesting,
                    onClick: _handleGoogleLoginButtonPressed,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  CircularIconButton(
                    urlOrName: "assets/svg/apple.svg",
                    imageSource: IconImageSource.local,
                    loading: appleLoginRequestState.requesting,
                    onClick: _handleAppleLoginButtonPressed,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${context.appLocalization.dont_have_account}  ",
                          style: context.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: context.appLocalization.create_account,
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkTheme
                                ? context.theme.primaryColorLight
                                : context.theme.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (!loginRequestState.requesting &&
                                  !googleLoginRequestState.requesting &&
                                  !appleLoginRequestState.requesting) {
                                context
                                    .pushNamed(AppRouter.register.toPathName);
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Method to handle login button pressed
  ///
  Future<void> _handleLoginButtonPressed() async {
    FocusScope.of(context).unfocus();

    if (_loginFormKey.currentState?.validate() == true) {
      final payloads = <String, dynamic>{};

      payloads['username'] = _usernameController.text.trim();
      payloads['password'] = _passwordController.text.trim();

      await ref.refresh(loginRequestStateProvider.notifier).login(
            payloads: payloads,
            onCompleted: (success) {
              // if (success) {
              //   _handleOnLoginSuccess();
              // }
              _handleOnLoginSuccess();
            },
          );
    }
  }

  /// Method to handle google login button pressed
  ///
  Future<void> _handleGoogleLoginButtonPressed() async {
    FocusScope.of(context).unfocus();

    await ref.refresh(googleLoginRequestStateProvider.notifier).login(
      onCompleted: (success) {
        if (success) {
          _handleOnLoginSuccess();
        }
      },
    );
  }

  /// Method to handle apple login button pressed
  ///
  Future<void> _handleAppleLoginButtonPressed() async {
    FocusScope.of(context).unfocus();

    await ref.refresh(appleLoginRequestStateProvider.notifier).login(
      onCompleted: (success) {
        if (success) {
          _handleOnLoginSuccess();
        }
      },
    );
  }

  void _handleOnLoginSuccess() {
    //invalidates the current state and works from start
    ref.invalidate(userLoggedInStateProvider);

    //fetching profile
    ref.read(userProfileStateProvider.notifier).fetchProfile();

    // If login success, navigate to home screen
    context.goNamed(AppRouter.home.toPathName);
  }

  /// Dispose
  ///
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
