import 'package:dio/dio.dart';

import '../typedef/either_forgot_password_response_or_exception.dart';
import '../typedef/either_login_response_exception.dart';
import '../typedef/either_register_response_or_exception.dart';

abstract class AuthRepository {
  ///  Base endpoint path for login
  ///
  String get path4Login;

  ///  Base endpoint path for google login
  ///
  String get path4GoogleLogin;

  ///  Base endpoint path for apple login
  ///
  String get path4AppleLogin;

  ///  Base endpoint path for register
  ///
  String get path4Register;

  ///  Base endpoint path for forget password
  ///
  String get path4ForgetPassword;

  /// Method to login
  ///
  Future<EitherLoginResponseOrException> login({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  });

  /// Method to handle register
  ///
  Future<EitherRegisterResponseOrException> register({
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  });

  /// Method to handle forgot password
  ///
  Future<EitherForgotPasswordResponseOrException> forgetPassword({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  });

  /// Method to handle google login
  ///
  Future<EitherLoginResponseOrException> googleLogin({
    List<String> scopes = const [],
    CancelToken? cancelToken,
  });

  /// Method to handle apple login
  ///
  Future<EitherLoginResponseOrException> appleLogin({
    CancelToken? cancelToken,
  });
}
