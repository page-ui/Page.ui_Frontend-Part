class MessageEntity {
  final String id;
  final String chatId;
  final String? senderId;
  final String content;
  final String type;
  final String status;
  final DateTime createdAt;
  final String? downloadUrl;
  final bool isDeleted;
  final bool isQuestion;

  const MessageEntity({
    required this.id,
    required this.chatId,
    this.senderId,
    required this.content,
    required this.type,
    required this.status,
    required this.createdAt,
    this.downloadUrl,
    this.isDeleted = false,
    this.isQuestion = false,
  });

  @Deprecated('Use downloadUrl instead')
  String? get attachmentUrl => downloadUrl;
}
