
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/inbox/message_cubit.dart';
import 'package:cinebond/models/inbox/message_model.dart' show Conversation, MessageType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────
//  MESSAGES VIEW  (ana ekran)
// ─────────────────────────────────────────────
class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit()..loadConversations(),
      child: const _MessagesBody(),
    );
  }
}

class _MessagesBody extends StatelessWidget {
  const _MessagesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: Stack(
        children: [
          const SafeArea(child: MessagesList()),

          BlocBuilder<MessagesCubit, MessagesState>(
            buildWhen: (p, c) {
              if (p is MessagesLoaded && c is MessagesLoaded) {
                return p.activeChat != c.activeChat;
              }
              return false;
            },
            builder: (context, state) {
              final chat = state is MessagesLoaded ? state.activeChat : null;
              return ChatPanel(conversation: chat);
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MESSAGES LIST
// ─────────────────────────────────────────────
class MessagesList extends StatelessWidget {
  const MessagesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7B5CF5)),
          );
        }
        if (state is MessagesError) {
          return Center(
            child: Text(state.message,
                style: const TextStyle(color: Colors.white54)),
          );
        }
        if (state is! MessagesLoaded) return const SizedBox.shrink();

        final convos = state.conversations;
        final newMatches = convos.where((c) => c.match.isNew).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Mesajlar',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF0F0F5),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E1E26)),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Color(0xFF888899), size: 18),
                  ),
                ],
              ),
            ),

            const VerticalSpacing( 18),

            // Match strip label
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                'EŞLEŞMELERİN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.10,
                  color: Color(0xFF888899),
                ),
              ),
            ),

            // Match bubbles
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: convos.length,
                separatorBuilder: (_, __) => const HorizontalSpacing( 12),
                itemBuilder: (context, i) => MatchedStoryboard(
                  conversation: convos[i],
                  onTap: () => context.read<MessagesCubit>().openChat(convos[i]),
                ),
              ),
            ),

            const VerticalSpacing( 6),

            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 1,
              color: const Color(0xFF1E1E26),
            ),

            // Conversations label
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 8),
              child: Text(
                'KONUŞMALAR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.10,
                  color: Color(0xFF888899),
                ),
              ),
            ),

            // Conversation rows
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: convos.length,
                itemBuilder: (context, i) => ConversationRow(
                  conversation: convos[i],
                  onTap: () => context.read<MessagesCubit>().openChat(convos[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  MATCH BUBBLE  (story halkası)
// ─────────────────────────────────────────────
class MatchedStoryboard extends StatelessWidget {
  const MatchedStoryboard({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final match = conversation.match;
    final isNew = match.isNew;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Gradient ring
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isNew
                        ? [const Color(0xFF00E676), const Color(0xFF2979FF)]
                        : [const Color(0xFF7B5CF5), const Color(0xFFFF4B6E)],
                  ),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0A0A0C),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: Image.network(
                      match.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF18181D),
                        child: const Icon(Icons.person, color: Colors.white38),
                      ),
                    ),
                  ),
                ),
              ),
              // Online dot
              if (match.isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF0A0A0C), width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const VerticalSpacing( 6),
          Text(
            match.name.split(' ').first,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isNew
                  ? const Color(0xFFF0F0F5)
                  : const Color(0xFF888899),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CONVERSATION ROW
// ─────────────────────────────────────────────
class ConversationRow extends StatelessWidget {
  const ConversationRow({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk';
    if (diff.inHours < 24) return '${diff.inHours} sa';
    return 'Dün';
  }

  @override
  Widget build(BuildContext context) {
    final match = conversation.match;
    final hasUnread = conversation.unreadCount > 0;
    final last = conversation.lastMessage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xFF7B5CF5).withOpacity(0.08),
        highlightColor: const Color(0xFF18181D),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  ClipOval(
                    child: Image.network(
                      match.avatarUrl,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 54,
                        height: 54,
                        color: const Color(0xFF18181D),
                        child: const Icon(Icons.person, color: Colors.white38),
                      ),
                    ),
                  ),
                  if (match.isOnline)
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF0A0A0C), width: 2),
                        ),
                      ),
                    ),
                ],
              ),

              const HorizontalSpacing( 14),

              // İsim + preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF0F0F5),
                            ),
                          ),
                        ),
                        if (last != null)
                          Text(
                            _timeAgo(last.sentAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF444455),
                            ),
                          ),
                      ],
                    ),
                    const VerticalSpacing( 3),
                    Text(
                      conversation.lastMessagePreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: hasUnread
                            ? const Color(0xFFF0F0F5)
                            : const Color(0xFF888899),
                        fontWeight: hasUnread
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const HorizontalSpacing(10),

              // Unread badge
              if (hasUnread)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B5CF5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHAT PANEL  (sağdan açılan)
// ─────────────────────────────────────────────
class ChatPanel extends StatefulWidget {
  const ChatPanel({this.conversation});
  final Conversation? conversation;

  @override
  State<ChatPanel> createState() => ChatPanelState();
}

class ChatPanelState extends State<ChatPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart));

    if (widget.conversation != null) _ctrl.forward();
  }

  @override
  void didUpdateWidget(ChatPanel old) {
    super.didUpdateWidget(old);
    if (widget.conversation != null && old.conversation == null) {
      _ctrl.forward();
      _scrollToBottom();
    } else if (widget.conversation == null && old.conversation != null) {
      _ctrl.reverse();
    }
    if (widget.conversation != null &&
        widget.conversation!.messages.length !=
            old.conversation?.messages.length) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<MessagesCubit>().sendMessage(text);
    _inputCtrl.clear();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Material(
        color: const Color(0xFF0A0A0C),
        child: BlocBuilder<MessagesCubit, MessagesState>(
          buildWhen: (p, c) {
            if (p is MessagesLoaded && c is MessagesLoaded) {
              return p.activeChat != c.activeChat;
            }
            return false;
          },
          builder: (context, state) {
            final convo = state is MessagesLoaded ? state.activeChat : null;
            if (convo == null) return const SizedBox.shrink();

            return SafeArea(
              child: Column(
                children: [
                  // ── Chat header ──
                  _buildHeader(context, convo),

                  // ── Match banner ──
                  if (convo.match.commonMovies.isNotEmpty)
                    _buildMatchBanner(convo),

                  // ── Messages ──
                  Expanded(child: _buildMessages(convo)),

                  // ── Input ──
                  _buildInput(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Conversation convo) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E26))),
      ),
      child: Row(
        children: [
          // Geri butonu
          GestureDetector(
            onTap: () => context.read<MessagesCubit>().closeChat(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF18181D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFF0F0F5), size: 16),
            ),
          ),
          const HorizontalSpacing(10),

          // Avatar
          ClipOval(
            child: Image.network(
              convo.match.avatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                color: const Color(0xFF18181D),
                child: const Icon(Icons.person, color: Colors.white38),
              ),
            ),
          ),
          const HorizontalSpacing( 10),

          // İsim + durum
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  convo.match.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF0F0F5),
                  ),
                ),
                if (convo.match.isOnline)
                  const Text(
                    '● Çevrimiçi',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00E676),
                        fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),

          // Aksiyon butonları
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF18181D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.movie_filter_outlined,
                color: Color(0xFF888899), size: 18),
          ),
          const HorizontalSpacing( 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF18181D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.more_horiz_rounded,
                color: Color(0xFF888899), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchBanner(Conversation convo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7B5CF5).withOpacity(0.12),
            const Color(0xFFFF4B6E).withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7B5CF5).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 22)),
          const HorizontalSpacing( 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Eşleştiniz!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF0F0F5),
                  ),
                ),
                Text(
                  'Ortak: ${convo.match.commonMovies.join(', ')}',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF888899)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7B5CF5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFF7B5CF5).withOpacity(0.4)),
            ),
            child: const Text(
              'Match',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7B5CF5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(Conversation convo) {
    return ListView.builder(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: convo.messages.length,
      itemBuilder: (context, i) {
        final msg = convo.messages[i];
        final isMe = msg.isMe;

        if (msg.type == MessageType.movieCard) {
          return MovieCardBubble(movieTitle: msg.movieTitle ?? '');
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFF7B5CF5)
                      : const Color(0xFF18181D),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 5),
                    bottomRight: Radius.circular(isMe ? 5 : 18),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe ? Colors.white : const Color(0xFFF0F0F5),
                    height: 1.45,
                  ),
                ),
              ),
              const VerticalSpacing( 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  _formatTime(msg.sentAt),
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF444455)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E1E26))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF18181D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1E1E26)),
              ),
              child: TextField(
                controller: _inputCtrl,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFFF0F0F5)),
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'Mesaj yaz...',
                  hintStyle: TextStyle(color: Color(0xFF444455)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 11),
                ),
              ),
            ),
          ),
          const HorizontalSpacing( 10),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFF7B5CF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_upward_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ─────────────────────────────────────────────
//  MOVIE CARD BUBBLE  (özel mesaj tipi)
// ─────────────────────────────────────────────
class MovieCardBubble extends StatelessWidget {
  const MovieCardBubble({required this.movieTitle});
  final String movieTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF18181D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E1E26)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF7B5CF5)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.movie_outlined,
                    color: Colors.white54, size: 18),
              ),
              const HorizontalSpacing( 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF0F0F5),
                    ),
                  ),
                  const VerticalSpacing( 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B5CF5).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Ortak film ✓',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7B5CF5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}