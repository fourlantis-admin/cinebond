import 'package:cinebond/controller/movie/favorites_movie_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/view/movie/movie_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviePosterItem extends StatefulWidget {
  final MovieResp movie;
  final bool overlayEnabled;
  const MoviePosterItem({
    super.key,
    required this.movie,
    this.overlayEnabled = true,
  });

  @override
  State<MoviePosterItem> createState() => _MoviePosterItemState();
}

class _MoviePosterItemState extends State<MoviePosterItem> {
  bool _isOverlayVisible = false;

  static const String _imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  static const double posterHeight = 180;
  static const double overlayHeightRatio = 0.58;

  double get _overlayHeight => posterHeight * overlayHeightRatio;

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final posterPath = widget.movie.poster_path;

    return BlocBuilder<FavoritesCubit, List<MovieResp>>(
      builder: (context, favorites) {
        final bool isFavorite = favorites.any((m) => m.id == widget.movie.id);

        return GestureDetector(
          onTap: widget.overlayEnabled ? _toggleOverlay : null,
          child: Center(
            child: AspectRatio(
              aspectRatio: 2/3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: posterPath == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(_imageBaseUrl + posterPath),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Stack(
                  children: [
                    if (widget.overlayEnabled)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _isOverlayVisible ? _overlayHeight : 0,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: AnimatedOpacity(
                            opacity: _isOverlayVisible ? 1 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(widget.movie);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetailView(
                                          movieId: widget.movie.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
