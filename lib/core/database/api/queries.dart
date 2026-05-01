class Queries {
  // ─── Auth ─────────────────────────────────────────────────────────
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
    mutation RefreshToken($refreshToken: String!) {
        refreshToken(refreshToken: $refreshToken) {
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
        }
      }
    ''';

  static String sendMessageMutation = r'''
    mutation CreateMessage($input: CreateMessageInput!) {
      createMessage(input: $input) {
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
        }
        pageInfo { hasNextPage endCursor }
      }
    }
    ''';

  static String searchChatQuery = r'''
    query SearchChats($name: String!, $first: Int, $after: String) {
      searchChats(name: $name, first: $first, after: $after) {
        nodes {
          id
          name
        }
        pageInfo {
          hasNextPage
          endCursor
        }
      }
    }
    ''';

  static String getMessagesQuery = r'''
    query GetMessages($chatId: UUID!, $first: Int, $after: String, $order: [MessageSortInput!]) {
      messages(
        chatId: $chatId
        first: $first
        after: $after
        order: $order
        where: { type: { nin: [THINKING] } }
      ) {
        totalCount
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            id
            senderId
            content
            type
            createdAt
            attachmentUrl
          }
        }
      }
    }
  ''';

  static String deleteChatMutation = r'''
    mutation DeleteChat($chatId: UUID!) {
      deleteChat(chatId: $chatId)
    }
  ''';

  static String renameChatMutation = r'''
    mutation RenameChat($input: RenameChatInput!) {
      renameChat(input: $input) {
        id
        name
      }
    }
  ''';

  static String onMessageCreatedSubscription = r'''
    subscription OnMessageCreated($chatId: UUID!) {
      onMessageCreated(chatId: $chatId) {
        id
        chatId
        senderId
        content
        type
        createdAt
        status
        attachmentUrl
        serverGeneratedId
      }
    }
  ''';
}
