import 'package:cinebond/components/movie/movie_poster_item.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';

class SelectMovieView extends StatefulWidget {
  const SelectMovieView({super.key});

  @override
  State<SelectMovieView> createState() => _SelectMovieViewState();
}

class _SelectMovieViewState extends State<SelectMovieView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateProfileCubit>().fetchMovies(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileCubit, CreateProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Favori Filmlerini Seç (${state.selectedMovies.length}/10)",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            VerticalSpacing(12),
            _buildSearchBar(context),
            VerticalSpacing(12),
            Expanded(
              child: state.isMoviesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildGrid(context, state),
            ),
          ],
        );
      },
    );
  }

  // ================= SEARCH =================

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          context.read<CreateProfileCubit>().searchMovie(context, value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Film ara...",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF220A43),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ================= GRID =================

  Widget _buildGrid(BuildContext context, CreateProfileState state) {
    return GridView.builder(
      itemCount: state.filteredMovies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        
      ),
      itemBuilder: (context, index) {
        final MovieResp movie = state.filteredMovies[index];
        final bool selected = state.selectedMovies.any((m) => m.id == movie.id);

        return GestureDetector(
          onTap: () {
            context.read<CreateProfileCubit>().toggleMovie(movie);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: MoviePosterItem(movie: movie, overlayEnabled: false),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: selected ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 42,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
