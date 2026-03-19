import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/models/user/generic_by_id_req.dart';
import 'package:cinebond/service/repositories/movie/movie_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/controller/explore/explore_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/models/user/generic_by_id_req.dart';
import 'package:cinebond/service/repositories/movie/movie_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FavoritesState {
  final List<MovieResp> favorites;
  final bool isLoading;

  FavoritesState({required this.favorites, required this.isLoading});

  factory FavoritesState.initial() {
    return FavoritesState(favorites: [], isLoading: false);
  }

  FavoritesState copyWith({List<MovieResp>? favorites, bool? isLoading}) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final MovieRepository movieRepository;

  Set<int> favoriteIds = {};

  FavoritesCubit({required this.movieRepository})
    : super(FavoritesState.initial());

  bool isFavorite(MovieResp movie) => favoriteIds.contains(movie.id);
  Future<void> toggleFavorite(MovieResp movie, BuildContext context) async {
    try {
      movie.isFavorite = !(movie.isFavorite ?? false);

      final req = GenericByIdReq(idInt: movie.id);
      final favoritesFromApi = await movieRepository.setFavoriteMovie(req);

      final favoriteIds = favoritesFromApi.map((e) => e.id!).toSet();

      emit(state.copyWith(favorites: favoritesFromApi));

      context.read<ExploreCubit>().syncFavorites(favoriteIds);
    } catch (e) {
      movie.isFavorite = !(movie.isFavorite ?? false);
    }
  }
}
