import 'package:dio/dio.dart';

import '../typedef/user_profile_response_or_exception.dart';

abstract class UserProfileRepository {
  ///  Base endpoint path for profile
  ///
  String get path;

  ///  Base endpoint path for profile update
  ///
  String get path4ProfileUpdate;

  /// Method to fetch user profile
  ///
  Future<EitherUserProfileResponseOrException> fetchProfile({
    required int? profileId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  });

  /// Method to handle profile update
  ///
  Future<EitherUserProfileResponseOrException> updateProfile({
    required int profileId,
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  });
}
