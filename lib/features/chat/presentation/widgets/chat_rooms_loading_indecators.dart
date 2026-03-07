import 'package:flutter/material.dart';
import 'package:pageui/features/chat/domain/entities/chat_entity.dart';
import 'package:pageui/features/chat/presentation/widgets/chat_room.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatRoomsLoadingIndecators extends StatelessWidget {
  const ChatRoomsLoadingIndecators({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          ChatRoom(
            chat: ChatEntity(id: "fsf", name: "name"),
          ),
          ChatRoom(
            chat: ChatEntity(id: "fsf", name: "name"),
          ),
          ChatRoom(
            chat: ChatEntity(id: "fsf", name: "name"),
          ),
        ],
      ),
    );
  }
}
