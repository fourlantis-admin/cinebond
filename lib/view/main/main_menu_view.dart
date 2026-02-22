import 'package:cinebond/components/navbar/custom_navbar.dart';
import 'package:cinebond/controller/game/game_cubit.dart';
import 'package:cinebond/controller/main-menu/main_menu_cubit.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/create-profile/create_profile_view.dart';
import 'package:cinebond/view/main/match/match_view.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/view/main/explore/explore_view.dart';
import 'package:cinebond/view/main/inbox/messages_view.dart';
import 'package:cinebond/view/main/play/game_lobby_screen.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> with ViewStateMixin {
  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();

    _views = [
      //CreateProfileView(),
      ExploreView(),
      MatchView(),
      MessagesView(),
      BlocProvider<GamesCubit>(
        create: (_) => GamesCubit()..loadLobby(),
        child: GamesLobbyScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainMenuCubit()),
        BlocProvider(create: (_) => LoadingCubit()),
      ],
      child: BlocBuilder<MainMenuCubit, int>(
        builder: (context, currentIndex) {
          context.read<MainMenuCubit>().checkInfo();

          return HomeBaseView(
            isLoadingActive: true,
            appBar: buildAppbarWithLogo(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: IndexedStack(index: currentIndex, children: _views),
            ),
            bottomNavigationBar: CustomNavbar(currentIndex: currentIndex),
          );
        },
      ),
    );
  }
}
