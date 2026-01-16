import 'package:cinebond/components/glass-container/glass_container.dart';
import 'package:cinebond/components/movie/movie_poster_item.dart';
import 'package:cinebond/components/searchbar/custom_searchbar.dart';
import 'package:cinebond/components/textfield/custom_title_widget.dart';
import 'package:cinebond/controller/explore/explore_cubit.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/main/explore/swipe_to_decide_view.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late final ExploreCubit _exploreCubit;

  @override
  void initState() {
    super.initState();
    _exploreCubit = ExploreCubit(repo: MovieRepository(context: context));
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
              Expanded(flex: 5, child: _buildFilmFinderRow(context)),
              VerticalSpacing(20),
              Expanded(flex: 12, child: _buildFeed(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          onChanged: (value) {
            context.read<ExploreCubit>().searchMovie(context, value);
          },
        ),
        VerticalSpacing(15),
        _buildGrid(),
      ],
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
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: MoviePosterItem(movie: state.filteredMovies[index]),
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
    return CustomTitleWidget(title: "Bugün ne izlesem?",);
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SwipeToDecideView()),
              );
            },
            child: GlassContainer(text: images[index]),
          );
        },
        separatorBuilder: (_, __) => HorizontalSpacing(3),
      ),
    );
  }
}
