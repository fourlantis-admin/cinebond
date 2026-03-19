
import 'package:cinebond/models/movie/actors_resp.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/repositories/movie/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreState {
  final List<MovieResp> movies;
    
  final List<ActorsResp> actors;

  final List<MovieResp> filteredMovies;
  final bool isLoading;

  const ExploreState({
    required this.movies,
    required this.filteredMovies,
    required this.isLoading,
    required this.actors
  });

  factory ExploreState.initial() {
    return const ExploreState(
      movies: [],
      filteredMovies: [],
      isLoading: false,
      actors: [],
    );
  }

  ExploreState copyWith({
    List<MovieResp>? movies,
    List<MovieResp>? filteredMovies,
    bool? isLoading,
    List<ActorsResp>? actors,
  }) {
    return ExploreState(
      movies: movies ?? this.movies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      isLoading: isLoading ?? this.isLoading,
      actors: actors ?? this.actors
    );
  }
}
class ExploreCubit extends Cubit<ExploreState> {
  final MovieRepository repo;

  ExploreCubit({required this.repo}) : super(ExploreState.initial());

  Future<void> getActors(BuildContext context) async {
    emit(state.copyWith(isLoading: false));
    try {
      final actors = await repo.getActors(context);
      print(actors);
      emit(state.copyWith(
        actors: actors,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }


  Future<void> getMovies(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      final movies = await repo.getMovies(context);

      emit(state.copyWith(
        movies: movies,
        filteredMovies: movies,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> searchMovie(BuildContext context, String query) async {
    if (query.length < 2) {
      emit(state.copyWith(filteredMovies: state.movies));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final results = await repo.getMovies(context, filter: query);

      // 🔥 FAVORITE MERGE YOK

      emit(state.copyWith(
        filteredMovies: results,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // 🔥 Toggle sonrası sync için bu kalır
  void syncFavorites(Set<int> ids) {
    final updatedMovies = state.movies.map((movie) {
      movie.isFavorite = ids.contains(movie.id);
      return movie;
    }).toList();

    final updatedFiltered = state.filteredMovies.map((movie) {
      movie.isFavorite = ids.contains(movie.id);
      return movie;
    }).toList();

    emit(state.copyWith(
      movies: updatedMovies,
      filteredMovies: updatedFiltered,
    ));
  }
}
