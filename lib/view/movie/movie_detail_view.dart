
import 'package:cinebond/components/movie/movie_ratings.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/movie/movie_detail_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



//********************************************************************************************************* */
//Detail service will be requested. However, get movies service was contain enough information about movies
//so i did not use any info from detail service in this view
//********************************************************************************************************* */

class MovieDetailView extends StatelessWidget {
  final String movieId;

  const MovieDetailView({super.key, required this.movieId});

  static const String _imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieDetailCubit(repo: MovieRepository(context: context))
            ..fetchMovieDetail(context, movieId),
      child: Scaffold(
        backgroundColor: const Color(0xFF140026),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final movie = state.movie;
            if (movie == null) {
              return Center(
                child: Text(
                  "Film detayı yüklenemedi",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(movie),
                  VerticalSpacing(25),
                  _buildMovieInfos(movie),
                  VerticalSpacing(50),
                  _buildContent(movie),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- UI PARÇALARI ----------------

  Widget _buildPoster(MovieResp movie) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: movie.poster_path == null
          ? Container(color: Colors.grey[800])
          : Image.network(_imageBaseUrl + movie.poster_path!, fit: BoxFit.fill),
    );
  }

  Widget _buildContent(MovieResp movie) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          VerticalSpacing(20),
          Text(
            movie.overview ?? "Açıklama bulunamadı.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfos(MovieResp movie) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            movie.release_date ?? "",
            style: TextStyle(color: Colors.white70),
          ),
          _buildMovieRatings(movie),
        ],
      ),
    );
  }

  Widget _buildMovieRatings(MovieResp movie) {
    final vote = movie.vote_average ?? 0;

    return Row(
      children: [
        MovieRatingStars(voteAverage: vote),
        HorizontalSpacing(10),
        Text(
          "${vote.toStringAsFixed(1)}/10",
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
