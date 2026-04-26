import 'message_content_codec.dart';

class CreateChatParams {
  final String name;
  final String content;
  final String? attachmentUrl;

  const CreateChatParams({
    required this.name,
    required this.content,
    this.attachmentUrl,
  });

  Map<String, dynamic> toInputJson() {
    final normalizedContent = _normalizeContent(
      content: content,
      attachmentUrl: attachmentUrl,
    );

    return {
      'name': name,
      'initialUserMessage': {
        'content': normalizedContent,
        if (attachmentUrl != null && attachmentUrl!.trim().isNotEmpty)
          'attachmentUrl': attachmentUrl,
      },
    };
  }
}

String _normalizeContent({
  required String content,
  required String? attachmentUrl,
}) {
  final normalizedLineEndings = encodeMessageContent(content);

  if (attachmentUrl == null || attachmentUrl.trim().isEmpty) {
    return normalizedLineEndings;
  }

  return normalizedLineEndings;
}
