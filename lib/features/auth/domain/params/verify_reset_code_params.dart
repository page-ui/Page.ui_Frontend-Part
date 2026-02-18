class VerifyResetCodeParams {
  String email;
  String code;

  VerifyResetCodeParams({required this.email, required this.code});

  // Map<String, dynamic> toJson() {
  //   return {'email': email, 'password': password, "returnSecureToken": true, "displayName" : userName};
  // }
}
