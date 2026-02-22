import 'package:cinebond/models/game/game_models.dart';
import 'package:cinebond/service/network_manager.dart';

// ─── Abstract Contract ────────────────────────
// Backend'e geçişte sadece GameRepository'yi gerçek
// implementasyonla değiştirmen yeterli; Cubit'e dokunmazsın.
abstract class IGameRepository {
  Future<List<Movie>> getEmojiQuestions();
  Future<List<Movie>> getStarringQuestions();
  Future<List<Movie>> getBlurredPosterQuestions();
}

// ─── Mock Implementation ──────────────────────
class GameRepository implements IGameRepository {
  // ignore: unused_field
  final NetworkManager _manager = NetworkManager();

  // Tek kaynak — film listesini buradan yönet.
  static const List<Movie> _mockMovies = [
    Movie(
      id: '1',
      title: 'Inception',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
      cast: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Elliot Page'],
      emoji: '🌀💤🏙️',
      year: 2010,
      genre: 'Sci-Fi',
    ),
    Movie(
      id: '2',
      title: 'The Godfather',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsLe1rjUC4LMH.jpg',
      cast: ['Marlon Brando', 'Al Pacino', 'James Caan'],
      emoji: '🌹🐟💼',
      year: 1972,
      genre: 'Crime',
    ),
    Movie(
      id: '3',
      title: 'Interstellar',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
      emoji: '🚀⭐🕳️',
      year: 2014,
      genre: 'Sci-Fi',
    ),
    Movie(
      id: '4',
      title: 'Joker',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      cast: ['Joaquin Phoenix', 'Robert De Niro', 'Zazie Beetz'],
      emoji: '🃏😂🩸',
      year: 2019,
      genre: 'Thriller',
    ),
    Movie(
      id: '5',
      title: 'Parasite',
      posterUrl:
          'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      cast: ['Song Kang-ho', 'Lee Sun-kyun', 'Cho Yeo-jeong'],
      emoji: '🏠🪲💰',
      year: 2019,
      genre: 'Thriller',
    ),
  ];

  // Yapay gecikme — backend'den geliyormuş hissi verir,
  // aynı zamanda loading state'ini gerçekçi test ettirir.
  Future<void> _mockDelay() =>
      Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<Movie>> getEmojiQuestions() async {
    await _mockDelay();
    // Gerçek backend: return await _manager.get('api/games/emoji');
    return _mockMovies;
  }

  @override
  Future<List<Movie>> getStarringQuestions() async {
    await _mockDelay();
    // Gerçek backend: return await _manager.get('api/games/starring');
    return _mockMovies;
  }

  @override
  Future<List<Movie>> getBlurredPosterQuestions() async {
    await _mockDelay();
    // Gerçek backend: return await _manager.get('api/games/blurred');
    return _mockMovies;
  }
}