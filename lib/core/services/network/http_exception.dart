import 'package:dio/dio.dart';
import '../router/app_router.dart';
import '../../../utils/extension_functions.dart';

/// Custom exception used with Http requests
class HttpException implements Exception {
  /// Creates a new instance of [HttpException]
  HttpException({
    this.title,
    this.message,
    this.statusCode,
    this.dioException,
  });

  /// Exception title
  final String? title;

  /// Exception message
  final String? message;

  /// Exception http response code
  final int? statusCode;

  /// Final DioException
  ///
  final DioException? dioException;

  /// Method to create HttpException from the response
  ///
  static HttpException fromResponse(Response<dynamic> response) {
    return HttpException(
      title: 'Data Response Error',
      statusCode: response.statusCode,
      message: response.data != null
          ? response.data['message'] ??
              response.data['Message'] ??
              response.data['details'] ??
              response.data['detail'] ??
              response.data['error'] ??
              response.statusMessage
          : response.statusMessage,
    );
  }

  /// Method to create HttpException from the exception
  ///
  static HttpException fromException(dynamic error) {
    return HttpException(
      statusCode: 502,
      title: 'Exception',
      message: AppRouter.rootNavigatorKey.currentContext?.appLocalization
              .request_handle_err ??
          'Unable to handle your request',
      dioException: error is DioException ? error : null,
    );
  }

  @override
  String toString() {
    return 'HttpException{title: $title, message: $message, statusCode: $statusCode, dioException: $dioException}';
  }
}
