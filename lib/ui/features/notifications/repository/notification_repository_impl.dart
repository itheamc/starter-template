import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../../core/services/network/http_exception.dart';
import '../../../../core/services/network/http_response_validator.dart';
import '../../../../core/services/network/http_service.dart';
import '../../../../core/services/network/models/multipart_form_data.dart';
import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/fcm_device_added_or_updated_response.dart';
import '../models/fcm_device_check_response.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  /// Http Service Instance
  final HttpService httpService;

  /// Constructor
  NotificationRepositoryImpl(this.httpService);

  ///  Base endpoint path for checking if fcm device already added or not
  ///
  @override
  String get path4CheckingFcmDevicesAlreadyAddedOrNot =>
      ApiEndpoints.checkFcmDeviceStatus;

  /// Endpoint for register fcm device
  ///
  @override
  String get path4registerFcmDevice => ApiEndpoints.fcmDeviceRegister;

  ///  Endpoint path for updating fcm device
  ///
  @override
  String get path4UpdateFcmDevice => ApiEndpoints.fcmDeviceUpdate;

  /// Method to check if fcm device is already registered or not
  ///
  @override
  Future<EitherResponseOrException<FcmDeviceCheckResponse>>
      checkIfDeviceAlreadyRegistered({
    required int? userId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.get(
        '$path4CheckingFcmDevicesAlreadyAddedOrNot$userId',
        forceRefresh: forceRefresh,
        cancelToken: cancelToken,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final fcmDeviceCheckResponse =
            FcmDeviceCheckResponse.fromJson(response.data);
        return Right(fcmDeviceCheckResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to register or update fcm device
  ///
  @override
  Future<EitherResponseOrException<FcmDeviceAddedOrUpdatedResponse>>
      registerOrUpdateFcmDevice({
    required Map<String, dynamic> payloads,
    int? deviceId, // Just for update
    bool update = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = update
          ? await httpService.put(
              "$path4UpdateFcmDevice$deviceId/",
              MultipartFormData(
                fields: payloads,
              ),
              contentType: ContentType.json,
              cancelToken: cancelToken,
            )
          : await httpService.post(
              path4registerFcmDevice,
              MultipartFormData(
                fields: payloads,
              ),
              contentType: ContentType.json,
              cancelToken: cancelToken,
            );

      if (ResponseValidator.isValidResponse(response)) {
        final fcmDeviceRegisterResponse =
            FcmDeviceAddedOrUpdatedResponse.fromJson(response.data);
        return Right(fcmDeviceRegisterResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }
}
