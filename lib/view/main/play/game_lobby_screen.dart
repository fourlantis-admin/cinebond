// ─────────────────────────────────────────────
// CineBond – Games Module: Lobby Screen
// ─────────────────────────────────────────────

import 'package:cinebond/components/game/game_card.dart';
import 'package:cinebond/components/game/pill_badge.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/models/game/game_models.dart';
import 'package:cinebond/view/main/play/theme/game_theme.dart';
import 'package:flutter/material.dart';

class GamesLobbyScreen extends StatefulWidget {
  const GamesLobbyScreen({super.key});

  @override
  State<GamesLobbyScreen> createState() => _GamesLobbyScreenState();
}

class _GamesLobbyScreenState extends State<GamesLobbyScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<double>> _cardAnimations = [];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    for (int i = 0; i < 3; i++) {
      final start = i * 0.2;
      _cardAnimations.add(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, start + 0.6, curve: Curves.easeOutCubic),
        ),
      );
    }

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CineBondColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildDailyChallenge(),
            _buildGamesGrid(),
            _buildLeaderboardTeaser(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OYUNLAR',
                    style: CineBondTextStyles.label.copyWith(
                      color: CineBondColors.primary,
                    ),
                  ),
                  const VerticalSpacing(4),
                  Text(
                    'Film Bilgini Test Et',
                    style: CineBondTextStyles.cardTitle,
                  ),
                ],
              ),
            ),
            PointsBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      sliver: SliverToBoxAdapter(child: DailyChallengeCard()),
    );
  }

  Widget _buildGamesGrid() {
    final games = [
      GameCardData(
        type: GameType.emojiGuess,
        title: 'Emoji Film',
        subtitle: 'Emojilerden filmi tahmin et',
        icon: '🎭',
        accent: CineBondColors.emojiAccent,
        gradient: CineBondColors.emojiGradient,
        difficulty: 'ORTA',
        points: '100 pts',
      ),
      GameCardData(
        type: GameType.blurredPoster,
        title: 'Blurlu Afiş',
        subtitle: 'Bulanık afişten filmi bul',
        icon: '🌫️',
        accent: CineBondColors.blurAccent,
        gradient: CineBondColors.blurGradient,
        difficulty: 'ZOR',
        points: '150 pts',
      ),
      GameCardData(
        type: GameType.starringGuess,
        title: 'Starring',
        subtitle: 'Oyunculardan filmi tahmin et',
        icon: '⭐',
        accent: CineBondColors.starAccent,
        gradient: CineBondColors.starGradient,
        difficulty: 'KOLAY',
        points: '75 pts',
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimatedBuilder(
            animation: _cardAnimations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 40 * (1 - _cardAnimations[index].value)),
                child: Opacity(
                  opacity: _cardAnimations[index].value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GameCard(data: games[index]),
            ),
          );
        }, childCount: games.length),
      ),
    );
  }

  Widget _buildLeaderboardTeaser() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CineBondColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CineBondColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CineBondColors.primaryGlow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 22)),
                ),
              ),
              HorizontalSpacing(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lider Tablosu', style: CineBondTextStyles.cardTitle),
                    const VerticalSpacing(2),
                    Text(
                      'Bu haftanın en iyi oyuncuları',
                      style: CineBondTextStyles.body.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: CineBondColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-Widgets ──────────────────────────────

class PointsBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CineBondColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CineBondColors.primary.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍿', style: TextStyle(fontSize: 16)),
          HorizontalSpacing(6),
          Text(
            '350 pts',
            style: CineBondTextStyles.cardTitle.copyWith(
              color: CineBondColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CineBondColors.primary.withOpacity(0.25),
            CineBondColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CineBondColors.primary.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GÜNLÜK MEYDAN OKUMA',
                  style: CineBondTextStyles.label.copyWith(
                    color: CineBondColors.primary,
                  ),
                ),
                const VerticalSpacing(6),
                Text('Bugünün Filmi', style: CineBondTextStyles.sectionTitle),
                const VerticalSpacing(4),
                Text(
                  'Her gün yeni bir film, özel ödüller!',
                  style: CineBondTextStyles.body.copyWith(fontSize: 12),
                ),
                const VerticalSpacing(12),
                Row(
                  children: [
                    PillBadge(
                      label: '🍿 250 pts',
                      color: CineBondColors.primary,
                    ),
                    HorizontalSpacing(8),
                    PillBadge(
                      label: '⏰ 20:00',
                      color: CineBondColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          HorizontalSpacing(12),
          Container(
            width: 72,
            height: 90,
            decoration: BoxDecoration(
              color: CineBondColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CineBondColors.border),
            ),
            child: const Center(
              child: Text('🎬', style: TextStyle(fontSize: 36)),
            ),
          ),
        ],
      ),
    );
  }
}
