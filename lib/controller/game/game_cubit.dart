// ─────────────────────────────────────────────
// CineBond – Games Module: Cubit & State
// ─────────────────────────────────────────────

import 'package:cinebond/models/game/game_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── State ────────────────────────────────────

abstract class GamesState extends Equatable {
  const GamesState();

  @override
  List<Object?> get props => [];
}

class GamesInitial extends GamesState {
  const GamesInitial();
}

class GamesLoading extends GamesState {
  const GamesLoading();
}

class GamesLobby extends GamesState {
  final Map<GameType, int> highScores;
  final Map<GameType, int> totalGamesPlayed;

  const GamesLobby({required this.highScores, required this.totalGamesPlayed});

  @override
  List<Object?> get props => [highScores, totalGamesPlayed];
}

class GameInProgress extends GamesState {
  final GameSession session;
  final int remainingTime;
  final String? selectedAnswer; // kullanıcı bu turu seçti
  final bool isAnswerRevealed;

  const GameInProgress({
    required this.session,
    required this.remainingTime,
    this.selectedAnswer,
    this.isAnswerRevealed = false,
  });

  @override
  List<Object?> get props => [
    session,
    remainingTime,
    selectedAnswer,
    isAnswerRevealed,
  ];

  GameInProgress copyWith({
    GameSession? session,
    int? remainingTime,
    String? selectedAnswer,
    bool? isAnswerRevealed,
  }) {
    return GameInProgress(
      session: session ?? this.session,
      remainingTime: remainingTime ?? this.remainingTime,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
    );
  }
}

class GameFinished extends GamesState {
  final GameResult result;

  const GameFinished({required this.result});

  @override
  List<Object?> get props => [result];
}

class GamesError extends GamesState {
  final String message;

  const GamesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────

class GamesCubit extends Cubit<GamesState> {
  GamesCubit() : super(const GamesInitial());

  // Simüle edilmiş high score store
  final Map<GameType, int> _highScores = {
    GameType.emojiGuess: 0,
    GameType.blurredPoster: 0,
    GameType.starringGuess: 0,
  };

  final Map<GameType, int> _totalGamesPlayed = {
    GameType.emojiGuess: 0,
    GameType.blurredPoster: 0,
    GameType.starringGuess: 0,
  };

  DateTime? _sessionStart;

  // Lobby yükle
  Future<void> loadLobby() async {
    emit(const GamesLoading());
    await Future.delayed(const Duration(milliseconds: 400));
    emit(
      GamesLobby(
        highScores: Map.from(_highScores),
        totalGamesPlayed: Map.from(_totalGamesPlayed),
      ),
    );
  }

  // Oyunu başlat
  Future<void> startGame(GameType type) async {
    List<GameQuestion> questions;
    switch (type) {
      case GameType.emojiGuess:
        questions = await GamePreparation.getEmojiQuestions();
        break;
      case GameType.blurredPoster:
        questions = await GamePreparation.getBlurredPosterQuestions();
        break;
      case GameType.starringGuess:
        questions = await GamePreparation.getStarringQuestions();
        break;
    }

    questions.shuffle();
    final session = GameSession(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      gameType: type,
      questions: questions,
      userAnswers: List.filled(questions.length, null),
      startedAt: DateTime.now(),
    );

    _sessionStart = DateTime.now();

    emit(
      GameInProgress(
        session: session,
        remainingTime: questions.first.timeLimit,
      ),
    );
  }

  // Cevap seç
  void selectAnswer(String answer) {
    final current = state;
    if (current is! GameInProgress) return;
    if (current.isAnswerRevealed) return;

    emit(current.copyWith(selectedAnswer: answer, isAnswerRevealed: true));
  }

  // Zamanlayıcı tick
  void tick() {
    final current = state;
    if (current is! GameInProgress) return;
    if (current.isAnswerRevealed) return;

    if (current.remainingTime <= 1) {
      // Süre doldu – cevapsız geç
      emit(
        current.copyWith(isAnswerRevealed: true, selectedAnswer: '__timeout__'),
      );
    } else {
      emit(current.copyWith(remainingTime: current.remainingTime - 1));
    }
  }

  // Sonraki soruya geç
  void nextQuestion() {
    final current = state;
    if (current is! GameInProgress) return;

    final session = current.session;
    final q = session.currentQuestion;
    final isCorrect = current.selectedAnswer == q.movie.title;
    final earned = isCorrect ? q.points : 0;

    final newAnswers = List<String?>.from(session.userAnswers);
    newAnswers[session.currentIndex] = current.selectedAnswer;

    final updatedSession = session.copyWith(
      currentIndex: session.currentIndex + 1,
      score: session.score + earned,
      userAnswers: newAnswers,
    );

    if (session.isLastQuestion) {
      _finishGame(updatedSession.copyWith(isComplete: true));
    } else {
      emit(
        GameInProgress(
          session: updatedSession,
          remainingTime: updatedSession.currentQuestion.timeLimit,
        ),
      );
    }
  }

  void _finishGame(GameSession session) {
    final correctAnswers = session.userAnswers
        .asMap()
        .entries
        .where((e) => e.value == session.questions[e.key].movie.title)
        .length;

    final timeTaken = DateTime.now().difference(_sessionStart!);

    final result = GameResult(
      gameType: session.gameType,
      score: session.score,
      totalQuestions: session.totalQuestions,
      correctAnswers: correctAnswers,
      pointsEarned: session.score,
      timeTaken: timeTaken,
    );

    // High score güncelle
    if (session.score > (_highScores[session.gameType] ?? 0)) {
      _highScores[session.gameType] = session.score;
    }
    _totalGamesPlayed[session.gameType] =
        (_totalGamesPlayed[session.gameType] ?? 0) + 1;

    emit(GameFinished(result: result));
  }

  void backToLobby() => loadLobby();
}
