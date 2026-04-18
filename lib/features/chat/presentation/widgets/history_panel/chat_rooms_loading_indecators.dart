import 'package:flutter/material.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/presentation/widgets/history_panel/chat_room.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatRoomsLoadingIndecators extends StatelessWidget {
  const ChatRoomsLoadingIndecators({super.key});

  static const _placeholderChats = [
    ChatEntity(id: 'chat-room-loading-1', name: 'Loading chat preview'),
    ChatEntity(id: 'chat-room-loading-2', name: 'Loading chat preview'),
    ChatEntity(id: 'chat-room-loading-3', name: 'Loading chat preview'),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: _placeholderChats.length,
        itemBuilder: (context, index) {
          return ChatRoom(chat: _placeholderChats[index]);
        },
      ),
    );
  }
}
