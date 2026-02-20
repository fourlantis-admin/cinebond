// ─────────────────────────────────────────────
// CineBond – Games Module: Models
// ─────────────────────────────────────────────

import 'dart:ui';

enum GameType { emojiGuess, blurredPoster, starringGuess }

enum GameDifficulty { easy, medium, hard }

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

class GameSession {
  final String sessionId;
  final GameType gameType;
  final List<GameQuestion> questions;
  final int currentIndex;
  final int score;
  final List<String?> userAnswers; // null = cevaplamadı
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

  GameQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex >= questions.length - 1;
  int get totalQuestions => questions.length;
  double get progressPercent => (currentIndex + 1) / totalQuestions;
}

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

  double get accuracy => correctAnswers / totalQuestions;
  String get grade {
    if (accuracy >= 0.9) return 'S';
    if (accuracy >= 0.7) return 'A';
    if (accuracy >= 0.5) return 'B';
    if (accuracy >= 0.3) return 'C';
    return 'D';
  }
}

// ─── Mock Data ────────────────────────────────
class GamePreparation {
  static const List<Movie> _movies = [
    Movie(
      id: '1',
      title: 'Inception',
      posterUrl: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
      cast: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Elliot Page'],
      emoji: '🌀💤🏙️',
      year: 2010,
      genre: 'Sci-Fi',
    ),
    Movie(
      id: '2',
      title: 'The Godfather',
      posterUrl: 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsLe1rjUC4LMH.jpg',
      cast: ['Marlon Brando', 'Al Pacino', 'James Caan'],
      emoji: '🌹🐟💼',
      year: 1972,
      genre: 'Crime',
    ),
    Movie(
      id: '3',
      title: 'Interstellar',
      posterUrl: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
      emoji: '🚀⭐🕳️',
      year: 2014,
      genre: 'Sci-Fi',
    ),
    Movie(
      id: '4',
      title: 'Joker',
      posterUrl: 'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      cast: ['Joaquin Phoenix', 'Robert De Niro', 'Zazie Beetz'],
      emoji: '🃏😂🩸',
      year: 2019,
      genre: 'Thriller',
    ),
    Movie(
      id: '5',
      title: 'Parasite',
      posterUrl: 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      cast: ['Song Kang-ho', 'Lee Sun-kyun', 'Cho Yeo-jeong'],
      emoji: '🏠🪲💰',
      year: 2019,
      genre: 'Thriller',
    ),
  ];

  static List<GameQuestion> getEmojiQuestions() {
    return _movies.map((movie) {
      final otherTitles = _movies
          .where((m) => m.id != movie.id)
          .map((m) => m.title)
          .toList()
        ..shuffle();
      final options = [movie.title, ...otherTitles.take(3)]..shuffle();

      return GameQuestion(
        id: 'emoji_${movie.id}',
        movie: movie,
        type: GameType.emojiGuess,
        difficulty: GameDifficulty.medium,
        options: options,
        points: 100,
        timeLimit: 20,
      );
    }).toList();
  }

  static List<GameQuestion> getBlurredPosterQuestions() {
    return _movies.map((movie) {
      final otherTitles = _movies
          .where((m) => m.id != movie.id)
          .map((m) => m.title)
          .toList()
        ..shuffle();
      final options = [movie.title, ...otherTitles.take(3)]..shuffle();

      return GameQuestion(
        id: 'blur_${movie.id}',
        movie: movie,
        type: GameType.blurredPoster,
        difficulty: GameDifficulty.hard,
        options: options,
        points: 150,
        timeLimit: 25,
      );
    }).toList();
  }

  static List<GameQuestion> getStarringQuestions() {
    return _movies.map((movie) {
      final otherTitles = _movies
          .where((m) => m.id != movie.id)
          .map((m) => m.title)
          .toList()
        ..shuffle();
      final options = [movie.title, ...otherTitles.take(3)]..shuffle();

      return GameQuestion(
        id: 'star_${movie.id}',
        movie: movie,
        type: GameType.starringGuess,
        difficulty: GameDifficulty.easy,
        options: options,
        points: 75,
        timeLimit: 30,
      );
    }).toList();
  }
}

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