class LoginResponse {
  LoginResponse({
    this.token,
    this.userId,
    this.profileId,
    this.email,
    this.username,
  });

  final String? token;
  final int? userId;
  final int? profileId;
  final String? email;
  final String? username;

  LoginResponse copyWith({
    String? token,
    int? userId,
    int? profileId,
    String? email,
    String? username,
  }) {
    return LoginResponse(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      userId: json["user_id"],
      profileId: json["user_profile_id"],
      email: json["email"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "profile_id": profileId,
        "email": email,
        "username": username,
      };

  @override
  String toString() {
    return "$token, $userId, $profileId, $email, $username, ";
  }
}
