import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/config/api_endpoints.dart';
import '../../../../core/services/network/http_exception.dart';
import '../../../../core/services/network/http_response_validator.dart';
import '../../../../core/services/network/http_service.dart';
import '../../../../core/services/network/models/form_file.dart';
import '../../../../core/services/network/models/multipart_form_data.dart';
import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/user_profile.dart';
import 'user_profile_repository.dart';

class UserProfileRepositoryImpl extends UserProfileRepository {
  /// Http Service Instance
  ///
  final HttpService httpService;

  /// Constructor
  ///
  UserProfileRepositoryImpl(this.httpService);

  ///  Base endpoint path for user profile
  ///
  @override
  String get path => ApiEndpoints.profile;

  ///  Base endpoint path for profile update
  ///
  @override
  String get path4ProfileUpdate => ApiEndpoints.profile;

  /// Method to fetch user profile
  ///
  @override
  Future<EitherResponseOrException<UserProfile>> fetchProfile({
    required int? profileId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.get(
        '$path$profileId',
        forceRefresh: forceRefresh,
        cancelToken: cancelToken,
      );

      if (ResponseValidator.isValidResponse(response)) {
        if (response.data['id'] != null) {
          final user = UserProfile.fromJson(response.data);
          return Right(user);
        }
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }

  /// Method to handle profile update
  ///
  @override
  Future<EitherResponseOrException<UserProfile>> updateProfile({
    required int profileId,
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await httpService.patch(
        '$path4ProfileUpdate$profileId/',
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
      );

      if (ResponseValidator.isValidResponse(response)) {
        if (response.data['id'] != null) {
          final user = UserProfile.fromJson(response.data);
          return Right(user);
        }
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }
}
