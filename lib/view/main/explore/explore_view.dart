import 'package:cinebond/components/items/movie_poster_item.dart';
import 'package:cinebond/controller/explore/explore_cubit.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView>{
  late final ExploreCubit _exploreCubit;

  @override
  void initState() {
    super.initState();
    _exploreCubit = ExploreCubit(
      repo: MovieRepository(context: context),
    );
    _exploreCubit.getMovies(context);
  }

  @override
  void dispose() {
    _exploreCubit.close();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _exploreCubit,
    child: Builder(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              flex: 5,
              child: _buildFilmFinderRow(context),
            ),
            VerticalSpacing(20),
            Expanded(
              flex: 12,
              child: _buildFeed(context),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildFeed(BuildContext context) {
  return Column(
    children: [
      _buildSearchBar(context),
      VerticalSpacing(5),
      _buildGrid(),
    ],
  );
}

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        onChanged: (value) {
          context.read<ExploreCubit>().searchMovie(context, value);
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Film ara...",
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF1F0A3D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return GridView.builder(
            itemCount: state.filteredMovies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: MoviePosterItem(
                  movie: state.filteredMovies[index],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= FILM FINDER =================

  Widget _buildFilmFinderRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidgetFinder(context),
        VerticalSpacing(13),
        _buildListWidgetFinder(),
      ],
    );
  }

  Widget _buildTitleWidgetFinder(BuildContext context) {
    return Text(
      "Bugün ne izlesem?",
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildListWidgetFinder() {
    final List<String> images = [
      "SWIPE_TO_DECIDE",
      "SPIN_TO_DECIDE_IMAGE",
      "TOURNAMENT_MODE",
    ];

    return Expanded(
      child: ListView.separated(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              height: 63,
              width: 170,
              color: Colors.white,
              child: Center(
                child: Text(
                  images[index],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => HorizontalSpacing(10),
      ),
    );
  }
}
