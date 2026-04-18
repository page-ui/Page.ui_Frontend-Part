import 'package:pageui/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  static const String defaultStatus = 'sent';

  const MessageModel({
    required super.id,
    required super.chatId,
    super.senderId,
    required super.content,
    required super.type,
    required super.status,
    required super.createdAt,
    super.attachmentUrl,
    super.isDeleted,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackChatId,
  }) {
    final chatId = (json['chatId'] as String?) ?? fallbackChatId;
    if (chatId == null || chatId.trim().isEmpty) {
      throw const FormatException('There is a missing message.');
    }

    return MessageModel(
      id: json['id'] as String,
      chatId: chatId,
      senderId: json['senderId'] as String?,
      content: json['content'] as String,
      type: json['type'] as String,
      status: (json['status'] as String?) ?? defaultStatus,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
      isDeleted: (json['isDeleted'] as bool?) ?? false,
    );
  }
}
