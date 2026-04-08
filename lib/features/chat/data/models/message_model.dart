import 'package:pageui/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String?,
      content: json['content'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
      isDeleted: (json['isDeleted'] as bool?) ?? false,
    );
  }
}
