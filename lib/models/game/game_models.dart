// ─────────────────────────────────────────────
// CineBond – Games Module: Models
// ─────────────────────────────────────────────
import 'dart:ui';

import 'package:cinebond/service/repositories/game/game_repository.dart';

enum GameType { emojiGuess, blurredPoster, starringGuess }

enum GameDifficulty { easy, medium, hard }

// ─── Movie ────────────────────────────────────
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final List<String> cast;
  final String emoji;
  final int year;
  final String genre;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.cast,
    required this.emoji,
    required this.year,
    required this.genre,
  });
}

// ─── GameQuestion ─────────────────────────────
class GameQuestion {
  final String id;
  final Movie movie;
  final GameType type;
  final GameDifficulty difficulty;
  final List<String> options;
  final int points;
  final int timeLimit;

  const GameQuestion({
    required this.id,
    required this.movie,
    required this.type,
    required this.difficulty,
    required this.options,
    required this.points,
    this.timeLimit = 30,
  });
}

// ─── GameSession ──────────────────────────────
class GameSession {
  final String sessionId;
  final GameType gameType;
  final List<GameQuestion> questions;
  final int currentIndex;
  final int score;
  final List<String?> userAnswers;
  final bool isComplete;
  final DateTime startedAt;

  const GameSession({
    required this.sessionId,
    required this.gameType,
    required this.questions,
    this.currentIndex = 0,
    this.score = 0,
    required this.userAnswers,
    this.isComplete = false,
    required this.startedAt,
  });

  GameSession copyWith({
    int? currentIndex,
    int? score,
    List<String?>? userAnswers,
    bool? isComplete,
  }) {
    return GameSession(
      sessionId: sessionId,
      gameType: gameType,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      userAnswers: userAnswers ?? this.userAnswers,
      isComplete: isComplete ?? this.isComplete,
      startedAt: startedAt,
    );
  }

  // Null-safe getter — index taşması durumunda crash vermez.
  GameQuestion? get currentQuestion {
    if (currentIndex >= questions.length) return null;
    return questions[currentIndex];
  }

  bool get isLastQuestion => currentIndex >= questions.length - 1;
  int get totalQuestions => questions.length;

  // currentIndex + 1 kullanıyoruz çünkü "şu anki soru kaçıncı" gösterimi için.
  double get progressPercent =>
      questions.isEmpty ? 0 : (currentIndex + 1) / totalQuestions;
}

// ─── GameResult ───────────────────────────────
class GameResult {
  final GameType gameType;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int pointsEarned;
  final Duration timeTaken;

  const GameResult({
    required this.gameType,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.pointsEarned,
    required this.timeTaken,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  String get grade {
    if (accuracy >= 0.9) return 'S';
    if (accuracy >= 0.7) return 'A';
    if (accuracy >= 0.5) return 'B';
    if (accuracy >= 0.3) return 'C';
    return 'D';
  }
}

// ─── GamePreparation ──────────────────────────
// Repository'den filmleri çeker, soru listesine dönüştürür.
// Tüm metodlar async — backend geçişinde Cubit'e dokunmana gerek kalmaz.
class GamePreparation {
  final IGameRepository _repository;

  GamePreparation({IGameRepository? repository})
      : _repository = repository ?? GameRepository();

  Future<List<GameQuestion>> getEmojiQuestions() async {
    final movies = await _repository.getEmojiQuestions();
    return _buildQuestions(
      movies: movies,
      idPrefix: 'emoji',
      type: GameType.emojiGuess,
      difficulty: GameDifficulty.medium,
      points: 100,
      timeLimit: 20,
    );
  }

  Future<List<GameQuestion>> getBlurredPosterQuestions() async {
    final movies = await _repository.getBlurredPosterQuestions();
    return _buildQuestions(
      movies: movies,
      idPrefix: 'blur',
      type: GameType.blurredPoster,
      difficulty: GameDifficulty.hard,
      points: 150,
      timeLimit: 25,
    );
  }

  Future<List<GameQuestion>> getStarringQuestions() async {
    final movies = await _repository.getStarringQuestions();
    return _buildQuestions(
      movies: movies,
      idPrefix: 'star',
      type: GameType.starringGuess,
      difficulty: GameDifficulty.easy,
      points: 75,
      timeLimit: 30,
    );
  }

  // Tekrar eden soru oluşturma mantığı tek yerde.
  List<GameQuestion> _buildQuestions({
    required List<Movie> movies,
    required String idPrefix,
    required GameType type,
    required GameDifficulty difficulty,
    required int points,
    required int timeLimit,
  }) {
    return movies.map((movie) {
      final otherTitles = movies
          .where((m) => m.id != movie.id)
          .map((m) => m.title)
          .toList()
        ..shuffle();

      final options = [movie.title, ...otherTitles.take(3)]..shuffle();

      return GameQuestion(
        id: '${idPrefix}_${movie.id}',
        movie: movie,
        type: type,
        difficulty: difficulty,
        options: options,
        points: points,
        timeLimit: timeLimit,
      );
    }).toList();
  }
}

// ─── GameCardData ─────────────────────────────
class GameCardData {
  final GameType type;
  final String title;
  final String subtitle;
  final String icon;
  final Color accent;
  final List<Color> gradient;
  final String difficulty;
  final String points;

  const GameCardData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.gradient,
    required this.difficulty,
    required this.points,
  });
}