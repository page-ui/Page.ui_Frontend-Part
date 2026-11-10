import 'message_content_codec.dart';

class CreateChatParams {
  final String content;
  final String? downloadUrl;

  const CreateChatParams({
    required this.content,
    this.downloadUrl,
  });

  @Deprecated('Use downloadUrl instead')
  String? get attachmentUrl => downloadUrl;

  Map<String, dynamic> toInputJson() {
    final normalizedContent = _normalizeContent(
      content: content,
      downloadUrl: downloadUrl,
    );

    return {
      'initialUserMessage': {
        'content': normalizedContent,
        if (downloadUrl != null && downloadUrl!.trim().isNotEmpty)
          'attachmentUrl': downloadUrl,
      },
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
