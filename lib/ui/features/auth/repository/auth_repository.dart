import 'package:dio/dio.dart';

import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/forget_password_response.dart';
import '../models/login_response.dart';
import '../models/register_response.dart';

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
  Future<EitherResponseOrException<LoginResponse>> login({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  });

  /// Method to handle register
  ///
  Future<EitherResponseOrException<RegisterResponse>> register({
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  });

  /// Method to handle forgot password
  ///
  Future<EitherResponseOrException<ForgotPasswordResponse>> forgetPassword({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  });

  /// Method to handle google login
  ///
  Future<EitherResponseOrException<LoginResponse>> googleLogin({
    List<String> scopes = const [],
    CancelToken? cancelToken,
  });

  /// Method to handle apple login
  ///
  Future<EitherResponseOrException<LoginResponse>> appleLogin({
    CancelToken? cancelToken,
  });
}
