
import 'package:cinebond/components/movie/movie_ratings.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/movie/movie_detail_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailView extends StatelessWidget {
  MovieResp movie;
  MovieDetailView({super.key, required this.movie});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieDetailCubit(repo: MovieRepository()),
            //..fetchMovieDetail(context, movieId),
      child: HomeBaseView(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // final movie = state.movie;
            // if (movie == null) {
            //   return const Center(
            //     child: Text(
            //       "Film detayı yüklenemedi",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   );
            // }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(movie),
                  _buildHeaderInfo(movie),
                  const VerticalSpacing(28),
                  _buildContent(movie),
                  const VerticalSpacing(40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= POSTER =================

  Widget _buildPoster(MovieResp movie) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          movie.imageUrl == null
              ? Container(color: Colors.grey[800])
              : Image.network(
                  "movie. + movie.imageUrl!",
                  fit: BoxFit.cover,
                ),

          /// 🔥 CINEMATIC GRADIENT OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER INFO =================

  Widget _buildHeaderInfo(MovieResp movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.name ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const VerticalSpacing(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                movie.year.toString(),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
              _buildMovieRatings(movie),
            ],
          ),
        ],
      ),
    );
  }

  // ================= CONTENT =================

  Widget _buildContent(MovieResp movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Özet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VerticalSpacing(12),
          Text(
            movie.description ?? "Açıklama bulunamadı.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ================= RATINGS =================

  Widget _buildMovieRatings(MovieResp movie) {
    final vote = movie.rating ?? 0;

    return Row(
      children: [
        MovieRatingStars(voteAverage: double.parse(vote.toString())),
        HorizontalSpacing(8),
        Text(
          "",
          //"${vote.toStringAsFixed(1)}/10",
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
