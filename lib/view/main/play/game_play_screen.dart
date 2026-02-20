// ─────────────────────────────────────────────
// CineBond – Games Module: Game Play Screen
// ─────────────────────────────────────────────

import 'dart:async';
import 'dart:ui';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/game/game_cubit.dart';
import 'package:cinebond/models/game/game_models.dart';
import 'package:cinebond/view/main/play/game_result_view.dart';
import 'package:cinebond/view/main/play/theme/game_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePlayScreen extends StatefulWidget {
  final GameType gameType;

  const GamePlayScreen({super.key, required this.gameType});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _questionTransitionController;
  late AnimationController _optionRevealController;
  late Animation<double> _questionFadeAnim;

  @override
  void initState() {
    super.initState();

    _questionTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _optionRevealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _questionFadeAnim = CurvedAnimation(
      parent: _questionTransitionController,
      curve: Curves.easeOut,
    );

    // _startTimerAndAnimation() buradan kaldırıldı
    // startGame, ekran mount olduktan sonra çağrılıyor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamesCubit>().startGame(widget.gameType);
      _startTimerAndAnimation();
    });
  }

  void _startTimerAndAnimation() {
    _questionTransitionController.forward(from: 0);
    _optionRevealController.forward(from: 0);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      context.read<GamesCubit>().tick();
    });
  }

  void _onAnswerSelected(String answer) {
    _timer?.cancel();
    context.read<GamesCubit>().selectAnswer(answer);
  }

  void _onNext() {
    final cubit = context.read<GamesCubit>();
    final state = cubit.state;

    if (state is GameInProgress && state.session.isLastQuestion) {
      cubit.nextQuestion();
      return;
    }

    _questionTransitionController.reverse().then((_) {
      cubit.nextQuestion();
      _startTimerAndAnimation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionTransitionController.dispose();
    _optionRevealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GamesCubit, GamesState>(
      listener: (context, state) {
        // game_play_screen.dart - BlocListener içinde:
        if (state is GameFinished) {
          _timer?.cancel();
          final cubit = context.read<GamesCubit>(); // ← ekle
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (ctx, anim, _) => BlocProvider.value(
                value: cubit, // ← ekle
                child: GameResultView(result: state.result),
              ),
              transitionsBuilder: (ctx, anim, _, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
        }
      },
      child: BlocBuilder<GamesCubit, GamesState>(
        builder: (context, state) {
          if (state is GamesLoading) {
            return const LoadingScreen();
          }

          if (state is! GameInProgress) {
            return const SizedBox();
          }

          return _GamePlayBody(
            state: state,
            questionFadeAnim: _questionFadeAnim,
            optionRevealController: _optionRevealController,
            onAnswerSelected: _onAnswerSelected,
            onNext: _onNext,
          );
        },
      ),
    );
  }
}

class _GamePlayBody extends StatelessWidget {
  final GameInProgress state;
  final Animation<double> questionFadeAnim;
  final AnimationController optionRevealController;
  final ValueChanged<String> onAnswerSelected;
  final VoidCallback onNext;

  const _GamePlayBody({
    required this.state,
    required this.questionFadeAnim,
    required this.optionRevealController,
    required this.onAnswerSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final q = state.session.currentQuestion;

    return Scaffold(
      backgroundColor: CineBondColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            GameHeader(state: state),
            Expanded(
              child: FadeTransition(
                opacity: questionFadeAnim,
                child: Column(
                  children: [
                    // Question area
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: QuestionWidget(question: q),
                      ),
                    ),
                    // Options
                    Expanded(
                      flex: 5,
                      child: OptionsGrid(
                        question: q,
                        selectedAnswer: state.selectedAnswer,
                        isRevealed: state.isAnswerRevealed,
                        revealController: optionRevealController,
                        onSelected: onAnswerSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Next Button
            if (state.isAnswerRevealed)
              NextButton(isLast: state.session.isLastQuestion, onTap: onNext),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────

class GameHeader extends StatelessWidget {
  final GameInProgress state;

  const GameHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final progress = session.progressPercent;
    final timePercent = state.remainingTime / session.currentQuestion.timeLimit;

    Color timerColor = CineBondColors.correct;
    if (timePercent < 0.5) timerColor = CineBondColors.starAccent;
    if (timePercent < 0.25) timerColor = CineBondColors.wrong;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.read<GamesCubit>().backToLobby();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CineBondColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CineBondColors.border),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: CineBondColors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
              HorizontalSpacing(12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: CineBondColors.surface,
                    valueColor: AlwaysStoppedAnimation(CineBondColors.primary),
                    minHeight: 6,
                  ),
                ),
              ),
              HorizontalSpacing(12),
              Text(
                '${session.currentIndex + 1}/${session.totalQuestions}',
                style: CineBondTextStyles.label.copyWith(
                  color: CineBondColors.textSecondary,
                ),
              ),
            ],
          ),
          VerticalSpacing(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Score
              Row(
                children: [
                  const Text('🍿', style: TextStyle(fontSize: 16)),
                  HorizontalSpacing(4),
                  Text(
                    '${session.score}',
                    style: CineBondTextStyles.sectionTitle.copyWith(
                      color: CineBondColors.primary,
                    ),
                  ),
                ],
              ),
              // Timer
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: timerColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: timerColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, color: timerColor, size: 14),
                    HorizontalSpacing(4),
                    Text(
                      '${state.remainingTime}s',
                      style: CineBondTextStyles.label.copyWith(
                        color: timerColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Question Widget ──────────────────────────

class QuestionWidget extends StatelessWidget {
  final GameQuestion question;

  const QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case GameType.emojiGuess:
        return EmojiQuestion(question: question);
      case GameType.blurredPoster:
        return BlurredPosterQuestion(question: question);
      case GameType.starringGuess:
        return StarringQuestion(question: question);
    }
  }
}

class EmojiQuestion extends StatelessWidget {
  final GameQuestion question;

  const EmojiQuestion({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CineBondColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CineBondColors.emojiAccent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bu emojiler hangi filmi anlatıyor?',
            style: CineBondTextStyles.body.copyWith(
              color: CineBondColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          VerticalSpacing(20),
          Text(
            question.movie.emoji,
            style: CineBondTextStyles.emoji,
            textAlign: TextAlign.center,
          ),
          VerticalSpacing(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CineBondColors.emojiAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🍿 ${question.points} pts · ⏰ ${question.timeLimit}s',
              style: CineBondTextStyles.label.copyWith(
                color: CineBondColors.emojiAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlurredPosterQuestion extends StatefulWidget {
  final GameQuestion question;

  const BlurredPosterQuestion({required this.question});

  @override
  State<BlurredPosterQuestion> createState() => BlurredPosterQuestionState();
}

class BlurredPosterQuestionState extends State<BlurredPosterQuestion> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesCubit, GamesState>(
      builder: (context, state) {
        final isRevealed = state is GameInProgress && state.isAnswerRevealed;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: CineBondColors.blurAccent.withOpacity(0.3),
            ),
          ),
          child: Stack(
            children: [
              // Poster
              Positioned.fill(
                child: Image.network(
                  widget.question.movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, e, s) => Container(
                    color: CineBondColors.surfaceElevated,
                    child: const Center(
                      child: Text('🎬', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                ),
              ),
              // Blur overlay — Positioned.fill KALDIRILDI, yerine Positioned.fill dışarıda
              if (!isRevealed)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      color: CineBondColors.bg.withOpacity(0.3),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🌫️', style: TextStyle(fontSize: 40)),
                            SizedBox(height: 8),
                            Text(
                              'Bu filmi tanıyabilir misin?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // Points badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: CineBondColors.blurAccent.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '🍿 ${widget.question.points} pts',
                    style: CineBondTextStyles.label.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StarringQuestion extends StatelessWidget {
  final GameQuestion question;

  const StarringQuestion({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CineBondColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CineBondColors.starAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bu oyuncular hangi filmde bir arada?',
            style: CineBondTextStyles.body.copyWith(
              color: CineBondColors.textMuted,
              fontSize: 13,
            ),
          ),
          VerticalSpacing(16),
          ...question.movie.cast.take(3).toList().asMap().entries.map((entry) {
            final i = entry.key;
            final actor = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: CineBondColors.starAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        ['⭐', '🌟', '✨'][i],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  HorizontalSpacing(12),
                  Text(actor, style: CineBondTextStyles.cardTitle),
                ],
              ),
            );
          }),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CineBondColors.starAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🍿 ${question.points} pts · ⏰ ${question.timeLimit}s',
              style: CineBondTextStyles.label.copyWith(
                color: CineBondColors.starAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Options ──────────────────────────────────

class OptionsGrid extends StatelessWidget {
  final GameQuestion question;
  final String? selectedAnswer;
  final bool isRevealed;
  final AnimationController revealController;
  final ValueChanged<String> onSelected;

  const OptionsGrid({
    required this.question,
    required this.selectedAnswer,
    required this.isRevealed,
    required this.revealController,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemCount: question.options.length,
              itemBuilder: (context, i) {
                final delay = i * 0.1;
                return AnimatedBuilder(
                  animation: revealController,
                  builder: (ctx, child) {
                    final t = ((revealController.value - delay) / 0.5).clamp(
                      0.0,
                      1.0,
                    );
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - t)),
                      child: Opacity(opacity: t, child: child),
                    );
                  },
                  child: OptionButton(
                    label: question.options[i],
                    correctAnswer: question.movie.title,
                    selectedAnswer: selectedAnswer,
                    isRevealed: isRevealed,
                    onTap: () => onSelected(question.options[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final String correctAnswer;
  final String? selectedAnswer;
  final bool isRevealed;
  final VoidCallback onTap;

  const OptionButton({
    required this.label,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = label == correctAnswer;
    final isSelected = label == selectedAnswer;
    final isTimeout = selectedAnswer == '__timeout__';

    Color borderColor = CineBondColors.border;
    Color bgColor = CineBondColors.surface;
    Color textColor = CineBondColors.textPrimary;
    IconData? icon;

    if (isRevealed && isCorrect) {
      borderColor = CineBondColors.correct;
      bgColor = CineBondColors.correctGlow;
      icon = Icons.check;
    } else if (isRevealed && isSelected && !isCorrect && !isTimeout) {
      borderColor = CineBondColors.wrong;
      bgColor = CineBondColors.wrongGlow;
      icon = Icons.close;
    }

    return GestureDetector(
      onTap: isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isRevealed && isCorrect ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: CineBondTextStyles.optionText.copyWith(
                    color: textColor,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: isCorrect
                      ? CineBondColors.correct
                      : CineBondColors.wrong,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Next Button ──────────────────────────────

class NextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onTap;

  const NextButton({required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: 1),
      builder: (ctx, v, child) => Transform.translate(
        offset: Offset(0, 40 * (1 - v)),
        child: Opacity(opacity: v, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: GestureDetector(
          onTap: onTap,
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
                isLast ? '🏆 Sonuçları Gör' : 'Sonraki →',
                style: CineBondTextStyles.cardTitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Loading Screen ───────────────────────────

class LoadingScreen extends StatelessWidget {
  const LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CineBondColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎬', style: TextStyle(fontSize: 56)),
            SizedBox(height: 16),
            CircularProgressIndicator(color: CineBondColors.primary),
          ],
        ),
      ),
    );
  }
}
