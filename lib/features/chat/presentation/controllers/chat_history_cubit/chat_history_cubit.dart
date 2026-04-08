import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pageui/features/chat/domain/repos/chat_repo.dart';
import 'package:pageui/features/chat/presentation/controllers/chat_history_cubit/chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final ChatRepo _chatRepo;

  ChatHistoryCubit({required ChatRepo chatRepo})
    : _chatRepo = chatRepo,
      super(const ChatHistoryInitial());
  int first = 15;
  Future<void> loadChats() async {
    emit(const ChatHistoryLoading());
    final result = await _chatRepo.getChats(first: first);
    result.fold(
      (failure) => emit(ChatHistoryFailure(message: failure.message)),
      (data) => emit(
        ChatHistoryLoaded(
          chats: data.chats,
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatHistoryLoaded ||
        !current.hasNextPage ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final result = await _chatRepo.getChats(
      first: first,
      after: current.endCursor,
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (data) => emit(
        ChatHistoryLoaded(
          chats: [...current.chats, ...data.chats],
          hasNextPage: data.hasNextPage,
          endCursor: data.endCursor,
        ),
      ),
    );
  }

  Future<void> searchChats({required String query}) async {
    if (query.isEmpty) {
      return loadChats();
    }

    emit(const ChatHistoryLoading());
    final result = await _chatRepo.searchChats(name: query, first: first);
    result.fold(
      (failure) => emit(ChatHistoryFailure(message: failure.message)),
      (data) => emit(
        ChatHistoryLoaded(chats: data, hasNextPage: false, endCursor: null),
      ),
    );
  }
}
