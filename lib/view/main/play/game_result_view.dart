// ─────────────────────────────────────────────
// CineBond – Games Module: Result Screen
// ─────────────────────────────────────────────

import 'dart:math' as math;
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/game/game_cubit.dart';
import 'package:cinebond/models/game/game_models.dart';
import 'package:cinebond/view/main/play/theme/game_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameResultView extends StatefulWidget {
  final GameResult result;

  const GameResultView({super.key, required this.result});

  @override
  State<GameResultView> createState() => _GameResultViewState();
}

class _GameResultViewState extends State<GameResultView>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _gradeController;
  late AnimationController _confettiController;
  late Animation<double> _scoreAnim;
  late Animation<double> _gradePop;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gradeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scoreAnim = CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    );
    _gradePop = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradeController, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _scoreController.forward();
      Future.delayed(const Duration(milliseconds: 800), () {
        _gradeController.forward();
        _confettiController.forward();
      });
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _gradeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String get _gradientEmoji {
    switch (widget.result.grade) {
      case 'S':
        return '🏆';
      case 'A':
        return '🌟';
      case 'B':
        return '👍';
      case 'C':
        return '🎬';
      default:
        return '💪';
    }
  }

  String get _gradeMessage {
    switch (widget.result.grade) {
      case 'S':
        return 'Efsane! Film tanrısısın!';
      case 'A':
        return 'Harika! Film meraklısısın!';
      case 'B':
        return 'İyi! Film bilgin var!';
      case 'C':
        return 'Fena değil! Pratik yapman lazım!';
      default:
        return 'Bir dahaki sefere daha iyi olacak!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return Scaffold(
      backgroundColor: CineBondColors.bg,
      body: Stack(
        children: [
          // Confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (ctx, _) => CustomPaint(
              size: MediaQuery.of(ctx).size,
              painter: _ConfettiPainter(progress: _confettiController.value),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  // Grade
                  AnimatedBuilder(
                    animation: _gradePop,
                    builder: (ctx, _) => Transform.scale(
                      scale: _gradePop.value,
                      child: _GradeBadge(
                        grade: result.grade,
                        emoji: _gradientEmoji,
                      ),
                    ),
                  ),
                  const VerticalSpacing(20),
                  Text(
                    _gradeMessage,
                    style: CineBondTextStyles.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpacing(8),
                  Text(
                    'Oyun bitti!',
                    style: CineBondTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpacing(36),
                  // Score counter
                  AnimatedBuilder(
                    animation: _scoreAnim,
                    builder: (ctx, _) {
                      final displayScore = (result.score * _scoreAnim.value)
                          .round();
                      return Column(
                        children: [
                          Text(
                            '🍿 $displayScore',
                            style: CineBondTextStyles.displayTitle.copyWith(
                              fontSize: 48,
                              color: CineBondColors.primary,
                            ),
                          ),
                          Text('puan kazandın', style: CineBondTextStyles.body),
                        ],
                      );
                    },
                  ),
                  const VerticalSpacing(36),
                  // Stats
                  _StatsRow(result: result),
                  const Spacer(),
                  // Actions
                  _ActionButtons(result: result),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final String grade;
  final String emoji;

  const _GradeBadge({required this.grade, required this.emoji});

  Color get _gradeColor {
    switch (grade) {
      case 'S':
        return const Color(0xFFFFD700);
      case 'A':
        return CineBondColors.correct;
      case 'B':
        return CineBondColors.blurAccent;
      case 'C':
        return CineBondColors.starAccent;
      default:
        return CineBondColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _gradeColor.withOpacity(0.15),
        border: Border.all(color: _gradeColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: _gradeColor.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          Text(
            grade,
            style: CineBondTextStyles.sectionTitle.copyWith(
              color: _gradeColor,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final GameResult result;

  const _StatsRow({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CineBondColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CineBondColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Doğru',
            value: '${result.correctAnswers}/${result.totalQuestions}',
            icon: '✅',
          ),
          _StatDivider(),
          _StatItem(
            label: 'Başarı',
            value: '${(result.accuracy * 100).round()}%',
            icon: '🎯',
          ),
          _StatDivider(),
          _StatItem(
            label: 'Süre',
            value: '${result.timeTaken.inSeconds}s',
            icon: '⏱️',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const VerticalSpacing(4),
        Text(value, style: CineBondTextStyles.sectionTitle),
        Text(label, style: CineBondTextStyles.label),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: CineBondColors.border);
  }
}

class _ActionButtons extends StatelessWidget {
  final GameResult result;

  const _ActionButtons({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.read<GamesCubit>().startGame(result.gameType);
            Navigator.of(context).pop();
          },
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CineBondColors.primary,
                  CineBondColors.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '🔄 Tekrar Oyna',
                style: CineBondTextStyles.cardTitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const VerticalSpacing(12),
        GestureDetector(
          onTap: () {
            context.read<GamesCubit>().backToLobby();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: CineBondColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CineBondColors.border),
            ),
            child: Center(
              child: Text(
                'Oyun Menüsü',
                style: CineBondTextStyles.cardTitle.copyWith(
                  color: CineBondColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Confetti Painter ─────────────────────────

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final _rng = math.Random(42);

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.01 || progress > 0.9) return;

    final colors = [
      CineBondColors.primary,
      CineBondColors.correct,
      CineBondColors.emojiAccent,
      CineBondColors.starAccent,
    ];

    for (int i = 0; i < 40; i++) {
      final x = (_rng.nextDouble() * size.width);
      final startY = -20.0;
      final endY = size.height * 1.2;
      final y =
          startY + (endY - startY) * progress + math.sin(progress * 6 + i) * 30;

      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(1 - progress * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 8, height: 8),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
