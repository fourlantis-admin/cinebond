import 'package:cinebond/components/items/movie_poster_item.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/movie/favorites_movie_cubit.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


//********************************************************************************************************* */
//Since favorite functionality needs to handle in local. I identified favorite functionality cubit global in the main.dart
//so that favorites movies features can used. It can also be done by local storage (shared_pref) but would likely have more workload
//********************************************************************************************************* */


class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<MovieResp>>(
      builder: (context, favorites) {
        if (favorites.isEmpty) {
          return const Center(
            child: Text(
              "Henüz favori eklenmedi",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
             VerticalSpacing(10),
            Expanded(
              child: _buildList(favorites),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Favorilerim",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildList(List<MovieResp> favorites) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (context, index) {
        return MoviePosterItem(
          movie: favorites[index],
        );
      },
    );
  }
}
