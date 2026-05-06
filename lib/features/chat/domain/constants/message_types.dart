class MessageType {
  MessageType._();

  static const String userMessage = 'USER_MESSAGE';
  static const String thinking = 'THINKING';
  static const String aiMessage = 'AI_MESSAGE';
  static const String aiRun = 'AI_RUN';
}

/// Returns true for AI_RUN messages (iframe URL).
bool isAiRunType(String value) =>
    value.trim().toUpperCase() == MessageType.aiRun;

/// Returns true for AI_MESSAGE messages (text response).
bool isAiMessageType(String value) =>
    value.trim().toUpperCase() == MessageType.aiMessage;

/// Returns true for THINKING messages (transient status).
bool isThinkingType(String value) =>
    value.trim().toUpperCase() == MessageType.thinking;

/// Returns true for any assistant-side message (AI_MESSAGE or AI_RUN).
bool isAssistantMessage(String value) =>
    isAiRunType(value) || isAiMessageType(value);
