class SendMessageParams {
  final String chatId;
  final String content;
  final String? attachmentUrl;

  const SendMessageParams({
    required this.chatId,
    required this.content,
    this.attachmentUrl,
  });

  SendMessageParams copyWith({
    String? chatId,
    String? content,
    String? attachmentUrl,
  }) {
    return SendMessageParams(
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }

  Map<String, dynamic> toInputJson() {
    return {
      'chatId': chatId,
      'content': content,
      'attachmentUrl': attachmentUrl,
    };
  }
}
