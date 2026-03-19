import 'package:cinebond/models/game/game_movies_resp.dart';
import 'package:cinebond/service/network_manager.dart';

abstract class IGameRepository {
  Future<List<GameMoviesResp>> getGameMovies({int count = 3});
}

class GameRepository implements IGameRepository {
  final NetworkManager networkManager = NetworkManager();

  @override
  Future<List<GameMoviesResp>> getGameMovies({int count = 3}) async {
    final response = await networkManager.get("api/games?count=$count");
    final List list = response["gameMovies"];
    print(list);
    return list.map((e) => GameMoviesResp.fromJson(e)).toList();
  }
}