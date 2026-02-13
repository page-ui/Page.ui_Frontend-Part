class SignupParams {
  String email;
  String password;
  String userName;

  SignupParams({
    required this.email,
    required this.password,
    required this.userName,
  });

  // Map<String, dynamic> toJson() {
  //   return {'email': email, 'password': password, "returnSecureToken": true, "displayName" : userName};
  // }
}
