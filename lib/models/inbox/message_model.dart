import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  MATCH MODEL
// ─────────────────────────────────────────────
class MatchModel {
  final String id;
  final String name;
  final String avatarUrl;
  final List<String> commonMovies;
  final bool isNew;
  final bool isOnline;
  final DateTime matchedAt;

  const MatchModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.commonMovies,
    this.isNew = false,
    this.isOnline = false,
    required this.matchedAt,
  });
}

// ─────────────────────────────────────────────
//  MESSAGE MODEL
// ─────────────────────────────────────────────
enum MessageType { text, movieCard }

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime sentAt;
  final MessageType type;
  final String? movieTitle; // type == movieCard ise dolu

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.sentAt,
    this.type = MessageType.text,
    this.movieTitle,
  });
}

// ─────────────────────────────────────────────
//  CONVERSATION MODEL
// ─────────────────────────────────────────────
class Conversation {
  final MatchModel match;
  final List<ChatMessage> messages;
  final int unreadCount;

  const Conversation({
    required this.match,
    required this.messages,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  String get lastMessagePreview {
    final last = lastMessage;
    if (last == null) return 'Henüz mesaj yok';
    if (last.type == MessageType.movieCard) return '🎬 ${last.movieTitle}';
    return last.isMe ? 'Sen: ${last.text}' : last.text;
  }
}

// ─────────────────────────────────────────────
//  MOCK DATA
//  İleride MessageRepository / MatchRepository
//  ile değiştirilecek.
// ─────────────────────────────────────────────
class MessagesData {
  static List<Conversation> getMockConversations() {
    final now = DateTime.now();

    return [
      Conversation(
        unreadCount: 2,
        match: MatchModel(
          id: '1',
          name: 'Zeynep K.',
          avatarUrl: 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
          commonMovies: ['Inception', 'LOTR'],
          isNew: true,
          isOnline: true,
          matchedAt: now.subtract(const Duration(minutes: 2)),
        ),
        messages: [
          ChatMessage(id: 'm1', text: 'Merhaba! Inception favorim 🌀', isMe: false, sentAt: now.subtract(const Duration(minutes: 10))),
          ChatMessage(id: 'm2', text: 'Ben de! Christopher Nolan\'ın en iyisi bence', isMe: true, sentAt: now.subtract(const Duration(minutes: 9))),
          ChatMessage(id: 'm3', text: 'Inception\'ı sen de seviyorsan buluşalım 🎬', isMe: false, sentAt: now.subtract(const Duration(minutes: 2))),
        ],
      ),
      Conversation(
        unreadCount: 1,
        match: MatchModel(
          id: '2',
          name: 'Defne A.',
          avatarUrl: 'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg',
          commonMovies: ['LOTR', 'The Godfather'],
          isNew: true,
          isOnline: true,
          matchedAt: now.subtract(const Duration(minutes: 17)),
        ),
        messages: [
          ChatMessage(id: 'm4', text: 'LOTR favori listemde kesinlikle 🧙', isMe: false, sentAt: now.subtract(const Duration(minutes: 17))),
        ],
      ),
      Conversation(
        match: MatchModel(
          id: '3',
          name: 'Ayşe B.',
          avatarUrl: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
          commonMovies: ['Joker'],
          isOnline: false,
          matchedAt: now.subtract(const Duration(hours: 1)),
        ),
        messages: [
          ChatMessage(id: 'm5', text: 'Joker\'ı nasıl buldun?', isMe: false, sentAt: now.subtract(const Duration(hours: 2))),
          ChatMessage(id: 'm6', text: '😂 harika', isMe: true, sentAt: now.subtract(const Duration(hours: 1))),
        ],
      ),
      Conversation(
        match: MatchModel(
          id: '4',
          name: 'Selin T.',
          avatarUrl: 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
          commonMovies: ['Parasite'],
          isOnline: false,
          matchedAt: now.subtract(const Duration(hours: 3)),
        ),
        messages: [
          ChatMessage(id: 'm7', text: 'Parasite\'i izledin mi hiç?', isMe: false, sentAt: now.subtract(const Duration(hours: 3))),
        ],
      ),
      Conversation(
        match: MatchModel(
          id: '5',
          name: 'Ceren M.',
          avatarUrl: 'https://images.pexels.com/photos/1542085/pexels-photo-1542085.jpeg',
          commonMovies: ['Interstellar', 'Inception'],
          isOnline: false,
          matchedAt: now.subtract(const Duration(days: 1)),
        ),
        messages: [
          ChatMessage(id: 'm8', text: 'ortak film zevkimiz çok var sanki', isMe: false, sentAt: now.subtract(const Duration(days: 1))),
        ],
      ),
    ];
  }
}