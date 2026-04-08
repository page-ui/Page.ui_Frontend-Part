import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/domain/entities/message_entity.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_messages_cubit/chat_messages_state.dart';

// class ChatMessagesCubit extends Cubit<ChatMessagesState> {
//   final Map<String, List<MessageEntity>> _messagesByChatId = {};
//   String? _activeChatId;

//   ChatMessagesCubit() : super(const ChatMessagesInitial());

//   void openChat({required String chatId}) {
//     _activeChatId = chatId;
//     // emit(ChatMessagesLoaded(messages: _messagesForChat(chatId)));
//   }

  // void appendMessage({required MessageEntity message}) {
  //   final messages = List<MessageEntity>.from(
  //     _messagesByChatId[message.chatId] ?? const [],
  //   );
  //   final alreadyExists = messages.any((existing) => existing.id == message.id);

  //   if (!alreadyExists) {
  //     messages.add(message);
  //     _messagesByChatId[message.chatId] = messages;
  //   }

  //   if (_activeChatId == message.chatId) {
  //     emit(ChatMessagesLoaded(messages: _messagesForChat(message.chatId)));
  //   }
  // }

  // List<MessageEntity> _messagesForChat(String chatId) {
  //   return List.unmodifiable(_messagesByChatId[chatId] ?? const []);
  // }

  // void reset() {
  //   _messagesByChatId.clear();
  //   _activeChatId = null;
  //   emit(const ChatMessagesInitial());
  // }
// }
