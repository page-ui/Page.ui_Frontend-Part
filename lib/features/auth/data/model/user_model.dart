class UserTokens {
  final String accessToken;
  final String refreshToken;

  UserTokens({required this.accessToken, required this.refreshToken});

  factory UserTokens.fromJson(Map<String, dynamic> json) {
    return UserTokens(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
