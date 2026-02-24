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
  static String resetPasswordMutation = r'''
    mutation ResetPassword($input: ResetPasswordInput!) {
    resetPassword(input: $input)
    }
    ''';
  static String refreshTokenMutation = r'''
    mutation Refresh($token: String!) {
      refreshToken(refreshToken: $token) {
        accessToken
        refreshToken
      }
    }
    ''';

  static String emailVerficationMutation = r'''
    mutation VerifyEmail($email: String!, $code: String!) {
      verifyEmail(email: $email, code: $code)
    }
    ''';

  static String resendVerificationMutation = r'''
    mutation ResendVerification($email: String!) {
      resendVerification(email: $email)
    }
    ''';

  static String signOutMutation = r'''
    mutation SignOut($refreshToken: String!) {
    signOut(refreshToken: $refreshToken)
  }
    ''';
  static String deleteAccountMutation = r'''
    mutation DeleteAccount {
    deleteAccount
  }
    ''';
}
