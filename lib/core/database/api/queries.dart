class Queries {
  static String loginMutation = r'''
    mutation Login($input: LoginInput!) {
      login(input: $input) {
        accessToken
        refreshToken
      }
    }
    ''';
  static String registerMutation = r'''
    mutation Register($input: RegisterInput!) {
      register(input: $input)
    }
    ''';
  static String forgotPasswordRequestMutation = r'''
    mutation ForgotPassword($email: String!) {
      forgotPasswordRequest(email: $email)
    }
    ''';
  static String verifyResetCodeMutation = r'''
    mutation VerifyCode($email: String!, $code: String!) {
      verifyResetCode(email: $email, code: $code)
    }
  ''';
  static String resetPassword = r'''
    mutation ResetPassword($input: ResetPasswordInput!) {
    resetPassword(input: $input)
    }
  ''';
  static String refreshToken = r'''
    mutation Refresh($token: String!) {
      refreshToken(refreshToken: $token) {
        accessToken
        refreshToken
      }
    }
''';
}
