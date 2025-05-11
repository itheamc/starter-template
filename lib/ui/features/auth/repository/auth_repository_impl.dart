import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/services/network/models/form_file.dart';
import '../../../../core/services/network/models/multipart_form_data.dart';
import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../../../../core/services/router/app_router.dart';
import '../../../../utils/extension_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../core/services/network/http_exception.dart';
import '../../../../core/services/network/http_response_validator.dart';
import '../../../../core/services/network/http_service.dart';
import '../../../../core/config/api_endpoints.dart';
import '../models/forget_password_response.dart';
import '../models/login_response.dart';
import '../models/register_response.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  /// Http Service Instance
  final HttpService httpService;

  /// Constructor
  AuthRepositoryImpl(this.httpService);

  ///  Base endpoint path for login
  ///
  @override
  String get path4Login => ApiEndpoints.login;

  ///  Base endpoint path for google login
  ///
  @override
  String get path4GoogleLogin => ApiEndpoints.googleLogin;

  ///  Base endpoint path for apple login
  ///
  @override
  String get path4AppleLogin => ApiEndpoints.appleLogin;

  ///  Base endpoint path for register
  ///
  @override
  String get path4Register => ApiEndpoints.register;

  ///  Base endpoint path for forget password
  ///
  @override
  String get path4ForgetPassword => ApiEndpoints.forgetPassword;

  /// Method to login
  ///
  @override
  Future<EitherResponseOrException<LoginResponse>> login({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.post(
        path4Login,
        MultipartFormData(
          fields: payloads,
        ),
        contentType: ContentType.json,
        cancelToken: cancelToken,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final loginResponse = await Isolate.run(() {
          return LoginResponse.fromJson(response.data);
        });
        return Right(loginResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to handle google login
  ///
  @override
  Future<EitherResponseOrException<LoginResponse>> googleLogin({
    List<String> scopes = const [],
    CancelToken? cancelToken,
  }) async {
    try {
      // Google Auth related codes to get access token
      final googleSignIn = GoogleSignIn(
        scopes: scopes,
      );

      // Sign out if already sign in
      final signedIn = await googleSignIn.isSignedIn();
      if (signedIn) await googleSignIn.signOut();

      // Now try to sign in
      final account = await googleSignIn.signIn();

      // Getting authentication
      final authentication = await account?.authentication;

      // Getting access token
      final accessToken = authentication?.accessToken;

      // Logging access token for debugging
      Logger.logMessage("Google Access Token: $accessToken");

      if (accessToken == null) {
        throw AppRouter.rootNavigatorKey.currentContext?.appLocalization
                .google_access_token_getting_err ??
            "Unable to get the access token.";
      }

      final response = await httpService.post(
        path4GoogleLogin,
        MultipartFormData(
          fields: {
            "access_token": accessToken,
          },
        ),
        contentType: ContentType.json,
        cancelToken: cancelToken,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final loginResponse = await Isolate.run(() {
          return LoginResponse.fromJson(response.data);
        });
        return Right(loginResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to handle apple login
  ///
  @override
  Future<EitherResponseOrException<LoginResponse>> appleLogin({
    CancelToken? cancelToken,
  }) async {
    try {
      // Getting apple id credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Getting identity token from credentials
      final identityToken = credential.identityToken;

      // Logging identity token for debugging
      Logger.logMessage("Apple Identity Token: $identityToken");

      // If identity token is null
      if (identityToken == null) {
        throw AppRouter.rootNavigatorKey.currentContext?.appLocalization
                .apple_identity_token_getting_err ??
            "Unable to get the identity token.";
      }

      final response = await httpService.post(
        path4AppleLogin,
        MultipartFormData(
          fields: {
            "access_token": identityToken,
          },
        ),
        contentType: ContentType.json,
        cancelToken: cancelToken,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final loginResponse = await Isolate.run(() {
          return LoginResponse.fromJson(response.data);
        });
        return Right(loginResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to handle register
  ///
  @override
  Future<EitherResponseOrException<RegisterResponse>> register({
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.post(
        path4Register,
        MultipartFormData(
          fields: payloads,
          files: medias?.keys
              .map(
                (k) => FormFile(
                  fieldName: k,
                  path: medias[k],
                ),
              )
              .toList(),
        ),
        contentType: ContentType.formData,
        cancelToken: cancelToken,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final registerResponse = await Isolate.run(() {
          return RegisterResponse.fromJson(response.data);
        });

        return Right(registerResponse);
      }

      return Left(
        HttpException(
          title: 'Data Error!',
          statusCode: response.statusCode,
          message: response.data != null
              ? (response.data['message'] is String)
                  ? response.data['message']
                  : (response.data['message'] as List<dynamic>).join(', ')
              : response.statusMessage,
        ),
      );
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to handle forgot password
  ///
  @override
  Future<EitherResponseOrException<ForgotPasswordResponse>> forgetPassword({
    required Map<String, dynamic> payloads,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.post(
        path4ForgetPassword,
        MultipartFormData(
          fields: payloads,
        ),
        contentType: ContentType.json,
        cancelToken: cancelToken,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final forgetPasswordResponse = await Isolate.run(() {
          return ForgotPasswordResponse.fromJson(response.data);
        });

        return Right(forgetPasswordResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }
}
