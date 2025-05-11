import 'package:dio/dio.dart';

import '../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/user_profile.dart';

abstract class UserProfileRepository {
  ///  Base endpoint path for profile
  ///
  String get path;

  ///  Base endpoint path for profile update
  ///
  String get path4ProfileUpdate;

  /// Method to fetch user profile
  ///
  Future<EitherResponseOrException<UserProfile>> fetchProfile({
    required int? profileId,
    bool forceRefresh = true,
    CancelToken? cancelToken,
  });

  /// Method to handle profile update
  ///
  Future<EitherResponseOrException<UserProfile>> updateProfile({
    required int profileId,
    required Map<String, dynamic> payloads,
    Map<String, dynamic>? medias,
    CancelToken? cancelToken,
  });
}
