import 'package:cinebond/components/swipe/tinder_environment.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/core/home_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchView extends StatefulWidget {
  const MatchView({super.key});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  List<Profile> _initialProfiles = [];

  @override
  void initState() {
    _initialProfiles = [
      Profile(
        nameAge: "Kubi, 25",
        occupation: "UX Designer",
        interests: "Hiking, Coffee, Indie Music",
        color: const Color(0xFFFF6384),
        picture: Image.network(
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
          fit: BoxFit.fill,
        ),
      ),
      Profile(
        nameAge: "Burak, 28",
        occupation: "Data Scientist",
        interests: "Astronomy, Cats, 80s Movies",
        color: const Color(0xFF4BC0C0),
        picture: Image.network(
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
          fit: BoxFit.fill,
        ),
      ),
      Profile(
        nameAge: "Ayça, 31",
        occupation: "Architect",
        interests: "Sketching, Jazz, Minimalism",
        color: const Color(0xFFFF9F40),
        picture: Image.network(
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
          fit: BoxFit.fill,
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SwipeCubit(profiles: _initialProfiles)),
        BlocProvider(create: (_) => LoadingCubit()),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<SwipeCubit, SwipeState>(
            listener: (context, state) async {
              if (state.shouldLoadMore) {
                context.read<LoadingCubit>().show();

                await Future.delayed(const Duration(seconds: 2));

                context.read<SwipeCubit>().addProfiles([
                  Profile(
                    nameAge: "Brit, 22",
                    occupation: "Senior Developer",
                    interests: "Godfather II, LOTR, Harry Potter",
                    color: const Color(0xFF6C63FF),
                    picture: Image.network(
                      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ]);

                context.read<LoadingCubit>().hide();
              }
            },
            child: HomeBaseView(
              body: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: TinderEnvironment(),
              ),
            ),
          );
        },
      ),
    );
  }
}
