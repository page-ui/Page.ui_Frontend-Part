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
    return {
      'name': name,
      'content': content,
      'attachmentUrl': attachmentUrl,
    };
  }
}
