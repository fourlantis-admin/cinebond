import 'package:cinebond/controller/movie/favorites_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
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
  late bool _isFavorite; // 👈 EKLEDİK

  static const double posterHeight = 200;
  static const double overlayHeightRatio = 0.38;

  double get _overlayHeight => posterHeight * overlayHeightRatio;
  @override
  void initState() {
    _isFavorite = widget.movie.isFavorite ?? false;

    // TODO: implement initState
    super.initState();
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listenWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      listener: (context, state) {
        final isLoading = state.isLoading;
        if (isLoading == true) {
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }
      },
      builder: (context, state) {

        final posterPath = widget.movie.imageUrl;

        return GestureDetector(
          onTap: _toggleOverlay,
          child: Center(
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: posterPath == null
                          ? null
                          : DecorationImage(
                              image: NetworkImage(posterPath),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  // Overlay
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
                                onPressed: () {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                  context.read<FavoritesCubit>().toggleFavorite(
                                    widget.movie,
                                    context
                                  );
                                },
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite
                                      ? Colors.red
                                      : Colors.white,
                                  size: 30,
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MovieDetailView(movie: widget.movie),
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
        );
      },
    );
  }
}
