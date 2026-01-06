import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipeToDecideState {
  final List<MovieResp> movies;
  final bool isLoading;

  const SwipeToDecideState({
    required this.movies,
    required this.isLoading,
  });

  factory SwipeToDecideState.initial() {
    return const SwipeToDecideState(
      movies: [],
      isLoading: false,
    );
  }

  SwipeToDecideState copyWith({
    List<MovieResp>? movies,
    bool? isLoading,
  }) {
    return SwipeToDecideState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


class SwipeToDecideCubit extends Cubit<SwipeToDecideState> {
  final MovieRepository repo;

  SwipeToDecideCubit({required this.repo})
      : super(SwipeToDecideState.initial());

  Future<void> getInitialMovies(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    try {
      final movies = await repo.getMovies(context);
      emit(state.copyWith(movies: movies, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMoreMovies(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    try {
      final movies = await repo.getMovies(context);
      emit(
        state.copyWith(
          movies: [...state.movies, ...movies],
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
