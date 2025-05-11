import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../core/config/flavor/configuration.dart';
import '../../config/api_endpoints.dart';
import '../connectivity/connectivity_service.dart';
import '../router/app_router.dart';
import '../../../utils/extension_functions.dart';
import '../storage/storage_keys.dart';
import 'http_exception.dart';
import '../storage/storage_service.dart';
import 'http_cache_interceptor.dart';
import 'http_response_validator.dart';
import 'http_service.dart';
import 'models/multipart_form_data.dart';

/// Http service implementation using the Dio package
///
/// See https://pub.dev/packages/dio
class DioHttpService implements HttpService {
  /// Creates new instance of [DioHttpService]
  DioHttpService(
      this.config,
      this.storageService, {
        Dio? dioOverride,
        bool enableCaching = true,
      }) {
    dio = dioOverride ?? Dio(baseOptions);
    if (enableCaching) {
      dio.interceptors.add(CacheInterceptor(config, storageService));
    }
  }

  /// Flavor Configuration
  ///
  final Configuration config;

  /// Storage service used for caching http responses
  ///
  final StorageService storageService;

  /// The Dio Http client
  ///
  late final Dio dio;

  /// The Dio base options
  ///
  BaseOptions get baseOptions => BaseOptions(
    baseUrl: baseUrl,
    headers: headers,
    connectTimeout: const Duration(minutes: 2),
    receiveTimeout: const Duration(minutes: 2),
  );

  /// Getter for base url
  ///
  @override
  String get baseUrl => config.apiBaseUrl;

  /// Getter for headers
  ///
  @override
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  /// Method to get a resource
  ///
  @override
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        bool forceRefresh = false,
        bool isAuthenticated = false,
        String? customBaseUrl,
        CancelToken? cancelToken,
      }) async {
    try {
      dio.options.extra[config.dioCacheForceRefreshKey] = forceRefresh;

      final Map<String, String> updatedHeaders = {
        ...headers,
        ..._getAuthHeaders(isAuthenticated),
      };

      final Response response = await dio.get(
        endpoint,
        options: Options(headers: updatedHeaders),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      final exception = await _handleError(e);

      if (isAuthenticated) {
        final refreshed = await _refresh(exception.dioException);

        if (refreshed) {
          return get(
            endpoint,
            queryParameters: queryParameters,
            forceRefresh: forceRefresh,
            isAuthenticated: isAuthenticated,
            customBaseUrl: customBaseUrl,
            cancelToken: cancelToken,
          );
        }
      }

      throw exception;
    }
  }

  /// Method to post a resource
  ///
  @override
  Future<Response> post(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        ContentType contentType = ContentType.formData,
        bool isAuthenticated = false,
        CancelToken? cancelToken,
      }) async {
    try {
      final Map<String, String> updatedHeaders = {
        ...headers,
        ..._getAuthHeaders(isAuthenticated),
        ..._getContentTypeHeader(contentType),
      };

      if (contentType == ContentType.string) {
        updatedHeaders.remove('Content-Type');
      }

      final data = await _prepareRequestData(formData, contentType);

      final Response response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: updatedHeaders),
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      final exception = await _handleError(e);

      if (isAuthenticated) {
        final refreshed = await _refresh(exception.dioException);

        if (refreshed) {
          return post(
            endpoint,
            formData,
            queryParameters: queryParameters,
            contentType: contentType,
            isAuthenticated: isAuthenticated,
            cancelToken: cancelToken,
          );
        }
      }

      throw exception;
    }
  }

  /// Method to put a resource
  ///
  @override
  Future<Response> put(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = false,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      }) async {
    try {
      final Map<String, String> updatedHeaders = {
        ...headers,
        ..._getAuthHeaders(isAuthenticated),
        ..._getContentTypeHeader(contentType),
      };

      if (contentType == ContentType.string) {
        updatedHeaders.remove('Content-Type');
      }

      final data = await _prepareRequestData(formData, contentType);

      final Response response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: updatedHeaders),
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      final exception = await _handleError(e);

      if (isAuthenticated) {
        final refreshed = await _refresh(exception.dioException);

        if (refreshed) {
          return put(
            endpoint,
            formData,
            queryParameters: queryParameters,
            contentType: contentType,
            isAuthenticated: isAuthenticated,
            cancelToken: cancelToken,
          );
        }
      }

      throw exception;
    }
  }

  /// Method to patch a resource
  ///
  @override
  Future<Response> patch(
      String endpoint,
      MultipartFormData formData, {
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = true,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      }) async {
    try {
      final Map<String, String> updatedHeaders = {
        ...headers,
        ..._getAuthHeaders(isAuthenticated),
        ..._getContentTypeHeader(contentType),
      };

      if (contentType == ContentType.string) {
        updatedHeaders.remove('Content-Type');
      }

      final data = await _prepareRequestData(formData, contentType);

      final Response response = await dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: updatedHeaders),
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      final exception = await _handleError(e);

      if (isAuthenticated) {
        final refreshed = await _refresh(exception.dioException);

        if (refreshed) {
          return patch(
            endpoint,
            formData,
            queryParameters: queryParameters,
            contentType: contentType,
            isAuthenticated: isAuthenticated,
            cancelToken: cancelToken,
          );
        }
      }

      throw exception;
    }
  }

  /// Method to delete a resource
  ///
  @override
  Future<Response> delete(
      String endpoint, {
        MultipartFormData? formData,
        Map<String, dynamic>? queryParameters,
        bool isAuthenticated = true,
        ContentType contentType = ContentType.json,
        CancelToken? cancelToken,
      }) async {
    try {
      final Map<String, String> updatedHeaders = {
        ...headers,
        ..._getAuthHeaders(isAuthenticated),
        ..._getContentTypeHeader(contentType),
      };

      if (contentType == ContentType.string) {
        updatedHeaders.remove('Content-Type');
      }

      final data = formData != null
          ? await _prepareRequestData(formData, contentType)
          : null;

      final Response response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: updatedHeaders),
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      final exception = await _handleError(e);

      if (isAuthenticated) {
        final refreshed = await _refresh(exception.dioException);

        if (refreshed) {
          return delete(
            endpoint,
            formData: formData,
            queryParameters: queryParameters,
            contentType: contentType,
            isAuthenticated: isAuthenticated,
            cancelToken: cancelToken,
          );
        }
      }

      throw exception;
    }
  }

  /// Method to download a file
  ///
  @override
  Future<Response> download(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        void Function(int count, int total)? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.get(
        endpoint,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration.zero,
        ),
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get authentication token header if required
  ///
  Map<String, String> _getAuthHeaders(bool isAuthenticated) {
    if (!isAuthenticated) return {};

    final token = storageService.get(StorageKeys.loggedInUserToken);
    return {"Authorization": 'Bearer $token'};
  }

  /// Get content type header based on ContentType
  ///
  Map<String, String> _getContentTypeHeader(ContentType contentType) {
    if (contentType != ContentType.formData) return {};

    return {'Content-Type': 'multipart/form-data'};
  }

  /// Handle API errors consistently
  ///
  Future<HttpException> _handleError(dynamic e) async {
    final dioError = e is DioException ? e : null;
    final statusCode = dioError?.response?.statusCode ?? 500;

    String message;
    if (dioError?.type == DioExceptionType.connectionError) {
      // Check if active internet connection is available or not
      final connected = await ConnectivityService.instance.hasActiveInternet();

      // Set message accordingly
      message = !connected
          ? (AppRouter.rootNavigatorKey.currentContext?.appLocalization
          .no_internet_connection ??
          'No active internet connection')
          : AppRouter.rootNavigatorKey.currentContext?.appLocalization
          .connectionError ??
          'Connection error';
    } else if (dioError != null) {
      message = dioError.message ?? 'Unknown error occurred';
    } else {
      message = AppRouter.rootNavigatorKey.currentContext?.appLocalization
          .request_handle_err ??
          "Unable to handle your request";
    }

    return HttpException(
      title: 'Http Error!',
      statusCode: statusCode,
      message: message,
      dioException: dioError,
    );
  }

  /// Prepare request data based on content type
  ///
  Future<dynamic> _prepareRequestData(
      MultipartFormData formData,
      ContentType contentType,
      ) async {
    return contentType == ContentType.formData
        ? await formData.toFormData
        : contentType == ContentType.json
        ? formData.nonNullFormFields
        : formData.nonNullFormFields.isNotEmpty
        ? jsonEncode(formData.nonNullFormFields)
        : "";
  }

  /// Attempts to refresh the access token using the stored refresh token.
  ///
  /// Returns `true` if the token was successfully refreshed, `false` otherwise.
  Future<bool> _refresh(DioException? err) async {
    // Proceed only if the error status code is 401 (unauthorized)
    if (err?.response?.statusCode != 401) return false;

    try {
      final refreshToken =
      await storageService.get(StorageKeys.loggedInUserRefreshToken);

      // If there's no stored refresh token, we can't refresh
      if (refreshToken == null || refreshToken.isEmpty) return false;

      // Attempt to refresh the token
      final response = await Dio(baseOptions).post(ApiEndpoints.refreshToken,
          data: {'refresh': refreshToken}, options: Options(headers: headers));

      // Validate the response
      if (!ResponseValidator.isValidResponse(response)) return false;

      final newAccessToken = response.data['access']?.toString();
      final newRefreshToken = response.data['refresh']?.toString();

      // Save new access token if valid
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await storageService.set(
          StorageKeys.loggedInUserToken,
          newAccessToken,
        );
      }

      // Save new refresh token if valid
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await storageService.set(
          StorageKeys.loggedInUserRefreshToken,
          newRefreshToken,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
