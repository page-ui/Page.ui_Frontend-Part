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

  // ─── Chat ─────────────────────────────────────────────────────────

  static String createChatRoomMutation = r'''
    mutation CreateChat($input: CreateChatInput!) {
        createChat(input: $input) {
          chat {
            id
            name
            chatKey
          }
          initialMessage {
            id
            content
          }
        }
      }
    ''';

  static String sendMessageMutation = r'''
    mutation SendMessage($input: SendMessageInput!) {
      sendMessage(input: $input) {
        id
        chatId
        content
        type
        status
        createdAt
        attachmentUrl
      }
    }
    ''';

  static String chatRoomsQuery = r'''
    query GetChats($first: Int, $after: String) {
      chats(first: $first, after: $after) {
        nodes {
          id
          name
          createdAt
          updatedAt
        }
        pageInfo { hasNextPage endCursor }
        totalCount
      }
    }
    ''';

  static String searchChatRoomsQuery = r'''
    query SearchChatRooms($name: String!, $first: Int) {
      searchChatRooms(name: $name, first: $first) {
        nodes {
          id
          name
          createdAt
          updatedAt
        }
        totalCount
      }
    }
    ''';

  static String chatMessagesQuery = r'''
    query ChatMessages($chatId: UUID!, $first: Int, $after: String) {
      chatMessages(chatId: $chatId, first: $first, after: $after) {
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            id
            chatId
            senderId
            content
            type
            status
            createdAt
            attachmentUrl
            isDeleted
          }
        }
        totalCount
      }
    }
    ''';
}
