import 'package:cinebond/view/main/match/tinder_environment.dart';
import 'package:cinebond/view/main/match/match_effect_overlay.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late final SwipeCubit<Profile> _swipeCubit;

  @override
  void initState() {
    super.initState();

    _swipeCubit = SwipeCubit<Profile>(
      items: [
        Profile(
          nameAge: "Emre, 28",
          occupation: "Software Developer",
          interests: "One Piece, LOTR, Inception",
          color: Colors.black,
          horoscope: "Aries",
          pictures: [
            Image.network(
              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
              fit: BoxFit.cover,
            ),
          ],
        ),
        Profile(
          nameAge: "Ayşe, 18",
          occupation: "UX Designer",
          interests: "One Piece, LOTR, Inception",
          horoscope: "Taurus",
          color: Colors.black,
          pictures: [
            Image.network(
              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
              fit: BoxFit.cover,
            ),
            Image.network(
              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _swipeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _swipeCubit,
      child: BlocListener<SwipeCubit<Profile>, SwipeState<Profile>>(
        listenWhen: (prev, curr) =>
            prev.shouldLoadMore != curr.shouldLoadMore,
        listener: (context, state) async {
          if (!state.shouldLoadMore) return;
          await Future.delayed(const Duration(seconds: 2));
          _swipeCubit.addItems([
            Profile(
              nameAge: "Fatma, 28",
              occupation: "Software Developer",
              interests: "One Piece, LOTR, Inception",
              color: Colors.black,
              horoscope: "Leo",
              pictures: [
                Image.network(
                  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ]);
        },
        child: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                // ── Ana swipe alanı ─────────────────
                TinderEnvironment<Profile>(
                  cardHeightRatio: 0.92,
                  bottomPadding: 0,
                  getColor: (_) => Colors.black,
                  getTitle: (p) => p.nameAge,
                  getSubtitle: (p) => p.occupation,
                  getDescription: (p) => p.interests,
                ),

                // ── Match effect overlay ─────────────
                // showMatchEffect true olduğunda ekranı kaplar.
                // matchedItem üzerinden servis entegrasyonu yapılacak:
                // → SwipeCubit._completeSwipe içindeki isMatch satırını
                //   MatchService.checkMatch(swiped) ile değiştir.
                BlocBuilder<SwipeCubit<Profile>, SwipeState<Profile>>(
                  buildWhen: (prev, curr) =>
                      prev.showMatchEffect != curr.showMatchEffect ||
                      prev.matchedItem != curr.matchedItem,
                  builder: (context, state) {
                    if (!state.showMatchEffect || state.matchedItem == null) {
                      return const SizedBox.shrink();
                    }

                    return MatchEffectOverlay<Profile>(
                      item: state.matchedItem!,
                      getName: (p) => p.nameAge,
                      getAvatarWidget: (p) => p.pictures.isNotEmpty
                          ? p.pictures.first
                          : const SizedBox.shrink(),
                      onDismiss: () =>
                          context.read<SwipeCubit<Profile>>().dismissMatchEffect(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}