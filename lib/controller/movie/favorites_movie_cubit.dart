import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<List<MovieResp>> {
  FavoritesCubit() : super([]);

  bool isFavorite(MovieResp movie) {
    return state.any((m) => m.id == movie.id);
  }

  void toggleFavorite(MovieResp movie) {
    if (isFavorite(movie)) {
      emit(
        state.where((m) => m.id != movie.id).toList(),
      );
    } else {
      emit([...state, movie]);
    }
  }

  void remove(MovieResp movie) {
    emit(
      state.where((m) => m.id != movie.id).toList(),
    );
  }
}
