import '../../../../ui/features/profile/models/user_profile.dart';

class UserProfileState {
  final bool fetching;
  final bool isUpdating;
  final String? error;
  final UserProfile? profile;

  UserProfileState({
    this.fetching = false,
    this.isUpdating = false,
    this.error,
    this.profile,
  });

  /// Method to copy
  UserProfileState copy({
    bool? fetching,
    bool? isUpdating,
    String? error,
    UserProfile? profile,
  }) {
    return UserProfileState(
      fetching: fetching ?? this.fetching,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error != null
          ? error.isEmpty
              ? null
              : error
          : this.error,
      profile: profile ?? this.profile,
    );
  }
}
