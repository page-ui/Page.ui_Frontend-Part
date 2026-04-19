const String aiMessageType = 'AI_RUN';

bool isAiMessageType(String value) =>
    value.trim().toUpperCase() == aiMessageType;
