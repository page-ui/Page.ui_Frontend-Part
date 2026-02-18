class Queries {
  static String loginMutation = r'''
    mutation Login($input: LoginInput!) {
      login(input: $input) {
        accessToken
        refreshToken
      }
    }
    ''';
  static String signupMutation = r'''
    mutation Register($input: RegisterInput!) {
      register(input: $input)
    }
    ''';
  static String forgotPasswordRequestMutation = r'''
    mutation ForgotPasswordRequest($email: String!) {
      forgotPasswordRequest(email: $email)
    }
    ''';
  // TODO: write it after receive the api
  static String verifyResetCodeMutation = r'''
  
  ''';
}
