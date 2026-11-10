import 'message_content_codec.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String? downloadUrl;

  const SendMessageParams({
    required this.chatId,
    required this.content,
    this.downloadUrl,
  });

  @Deprecated('Use downloadUrl instead')
  String? get attachmentUrl => downloadUrl;

  SendMessageParams copyWith({
    String? chatId,
    String? content,
    String? downloadUrl,
  }) {
    return SendMessageParams(
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  Map<String, dynamic> toInputJson() {
    final normalizedContent = _normalizeContent(
      content: content,
      downloadUrl: downloadUrl,
    );

    return {
      'chatKey': chatId,
      'content': normalizedContent,
      if (downloadUrl != null && downloadUrl!.trim().isNotEmpty)
        'attachmentUrl': downloadUrl,
    };
  }
}

String _normalizeContent({
  required String content,
  required String? downloadUrl,
}) {
  final normalizedLineEndings = encodeMessageContent(content);

  if (downloadUrl == null || downloadUrl.trim().isEmpty) {
    return normalizedLineEndings;
  }

  return normalizedLineEndings;
}
