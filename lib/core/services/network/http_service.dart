import 'package:dio/dio.dart';
import 'models/multipart_form_data.dart';

/// A service interface for handling HTTP requests, including various methods
/// to send HTTP requests such as GET, POST, PUT, PATCH, DELETE, and download.
abstract class HttpService {
  /// The base URL for HTTP requests.
  /// This URL is the root endpoint for all the requests in the service.
  String get baseUrl;

  /// The headers that should be included in the HTTP request.
  /// Typically includes authentication tokens, content type, etc.
  Map<String, String> get headers;

  /// Sends a GET request to the given [endpoint].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [isAuthenticated] - Flag indicating if authentication is required (default is true).
  /// [forceRefresh] - Flag to force the refresh of data (default is false).
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = true,
        bool forceRefresh = false,
        CancelToken? cancelToken,
      });

  /// Sends a POST request to the given [endpoint] with [formData].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [formData] - Data to send in the body of the POST request, typically as multipart/form-data.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [contentType] - Specifies the content type of the request (default is [ContentType.formData]).
  /// [isAuthenticated] - Flag indicating if authentication is required (default is false).
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> post(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        ContentType contentType = ContentType.formData,
        bool isAuthenticated = false,
        CancelToken? cancelToken,
      });

  /// Sends a PUT request to the given [endpoint] with [formData].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [formData] - Data to send in the body of the PUT request, typically as multipart/form-data.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [isAuthenticated] - Flag indicating if authentication is required (default is true).
  /// [contentType] - Specifies the content type of the request (default is [ContentType.json]).
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> put(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = true,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      });

  /// Sends a PATCH request to the given [endpoint] with [formData].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [formData] - Data to send in the body of the PATCH request, typically as multipart/form-data.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [isAuthenticated] - Flag indicating if authentication is required (default is true).
  /// [contentType] - Specifies the content type of the request (default is [ContentType.json]).
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> patch(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = true,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      });

  /// Sends a GET request to download data from the given [endpoint].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [onReceiveProgress] - A callback function to report download progress.
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> download(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        void Function(int count, int total)? onReceiveProgress,
        CancelToken? cancelToken,
      });

  /// Sends a DELETE request to the given [endpoint] with optional [formData].
  ///
  /// [endpoint] - The URL path to append to [baseUrl] for the request.
  /// [formData] - Optional data to send in the body of the DELETE request.
  /// [queryParameters] - Optional parameters to include in the URL query string.
  /// [isAuthenticated] - Flag indicating if authentication is required (default is false).
  /// [contentType] - Specifies the content type of the request (default is [ContentType.json]).
  /// [cancelToken] - Token to cancel the request before completion.
  Future<Response> delete(
      String endpoint, {
        MultipartFormData? formData,
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = false,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      });
}

/// Enum to represent the content types for the HTTP request body.
/// - [json] indicates JSON data.
/// - [formData] indicates multipart/form-data data.
///
enum ContentType {
  /// Application/JSON content type
  ///
  json,

  /// Multipart form data content type
  ///
  formData,

  /// Raw String
  string
}
