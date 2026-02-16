class ResetPasswordParams {
  final String email;
  final String code;
  final String newPassword;

  ResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "input": {"email": email, "code": code, "newPassword": newPassword},
  };
}
