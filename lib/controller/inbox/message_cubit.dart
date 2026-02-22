import 'package:cinebond/models/inbox/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────
//  STATE
// ─────────────────────────────────────────────
abstract class MessagesState {
  const MessagesState();
}

class MessagesInitial extends MessagesState {
  const MessagesInitial();
}

class MessagesLoading extends MessagesState {
  const MessagesLoading();
}

class MessagesLoaded extends MessagesState {
  final List<Conversation> conversations;
  final Conversation? activeChat; // sağda açık olan

  const MessagesLoaded({
    required this.conversations,
    this.activeChat,
  });

  MessagesLoaded copyWith({
    List<Conversation>? conversations,
    Conversation? activeChat,
    bool clearActiveChat = false,
  }) {
    return MessagesLoaded(
      conversations: conversations ?? this.conversations,
      activeChat: clearActiveChat ? null : activeChat ?? this.activeChat,
    );
  }
}

class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);
}

// ─────────────────────────────────────────────
//  CUBIT
// ─────────────────────────────────────────────
class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(const MessagesInitial());

  Future<void> loadConversations() async {
    emit(const MessagesLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    emit(MessagesLoaded(conversations: MessagesData.getMockConversations()));
  }

  void openChat(Conversation conversation) {
    final current = state;
    if (current is! MessagesLoaded) return;

    final updated = current.conversations.map((c) {
      if (c.match.id == conversation.match.id) {
        return Conversation(
          match: c.match,
          messages: c.messages,
          unreadCount: 0,
        );
      }
      return c;
    }).toList();

    emit(current.copyWith(conversations: updated, activeChat: conversation));
  }

  void closeChat() {
    final current = state;
    if (current is! MessagesLoaded) return;
    emit(current.copyWith(clearActiveChat: true));
  }

  void sendMessage(String text) {
    final current = state;
    if (current is! MessagesLoaded) return;
    final chat = current.activeChat;
    if (chat == null || text.trim().isEmpty) return;

    final newMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isMe: true,
      sentAt: DateTime.now(),
    );

    final updatedMessages = [...chat.messages, newMsg];
    final updatedChat = Conversation(
      match: chat.match,
      messages: updatedMessages,
      unreadCount: 0,
    );

    final updatedConversations = current.conversations.map((c) {
      if (c.match.id == chat.match.id) return updatedChat;
      return c;
    }).toList();

    emit(current.copyWith(
      conversations: updatedConversations,
      activeChat: updatedChat,
    ));
  }
}