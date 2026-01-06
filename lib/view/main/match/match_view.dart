import 'package:cinebond/components/swipe/tinder_environment.dart';
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
          nameAge: "Kubi, 25",
          occupation: "UX Designer",
          interests: "Hiking, Coffee, Indie Music",
          color: const Color(0xFFFF6384),
          picture: Image.network(
            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Profile(
          nameAge: "Burak, 28",
          occupation: "Data Scientist",
          interests: "Astronomy, Cats, 80s Movies",
          color: const Color(0xFF4BC0C0),
          picture: Image.network(
            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
            fit: BoxFit.cover,
          ),
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

          context.read<LoadingCubit>().show();

          await Future.delayed(const Duration(seconds: 2));

          _swipeCubit.addItems([
            Profile(
              nameAge: "Brit, 22",
              occupation: "Senior Developer",
              interests: "Godfather II, LOTR, Harry Potter",
              color: const Color(0xFF6C63FF),
              picture: Image.network(
                'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Profile(
              nameAge: "Alex, 27",
              occupation: "Product Manager",
              interests: "Cinema, UX, Startups",
              color: const Color(0xFF00BFA6),
              picture: Image.network(
                'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ]);

          context.read<LoadingCubit>().hide();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: TinderEnvironment<Profile>(
            getColor: (p) => p.color,
            getImage: (p) => p.picture,
            getTitle: (p) => p.nameAge,
            getSubtitle: (p) => p.occupation,
            getDescription: (p) => p.interests,
          ),
        ),
      ),
    );
  }
}
