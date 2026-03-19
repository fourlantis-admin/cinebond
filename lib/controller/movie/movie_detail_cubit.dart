import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/repositories/movie/movie_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailState {
  final MovieResp? movie;
  final bool isLoading;

  const MovieDetailState({
    this.movie,
    required this.isLoading,
  });

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movie: null,
      isLoading: false,
    );
  }

  MovieDetailState copyWith({
    MovieResp? movie,
    bool? isLoading,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository repo;

  MovieDetailCubit({required this.repo})
      : super(MovieDetailState.initial());

  // Future<void> fetchMovieDetail(
  //   BuildContext context,
  //   String movieId,
  // ) async {
  //   emit(state.copyWith(isLoading: true));

  //   try {
  //     final movie = await repo.getMovieDetail(context, movieId);

  //     emit(state.copyWith(
  //       movie: movie,
  //       isLoading: false,
  //     ));
  //   } catch (_) {
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }
}

