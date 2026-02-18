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
}
