import 'package:cinebond/components/swipe/tinder_environment.dart';
import 'package:cinebond/controller/explore/swipe_to_decide_cubit.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/main/main_menu_view.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwipeToDecideView extends StatefulWidget {
  const SwipeToDecideView({super.key});

  @override
  State<SwipeToDecideView> createState() => _SwipeToDecideViewState();
}

class _SwipeToDecideViewState extends State<SwipeToDecideView> with ViewStateMixin {
  late final SwipeCubit<MovieResp> _swipeCubit;
  late final SwipeToDecideCubit _pageCubit;
  static const String _imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  @override
  void initState() {
    super.initState();

    _swipeCubit = SwipeCubit<MovieResp>(items: []);
    _pageCubit = SwipeToDecideCubit(
      repo: MovieRepository(context: context),
    );

    _pageCubit.getInitialMovies(context);
  }

  @override
  void dispose() {
    _swipeCubit.close();
    _pageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeBaseView(
      appBar: buildAppbarWithBackButton(onBackButtonPressed: (){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainMenuView()),
          (Route<dynamic> route) => false,
        );
      }),
      isLoadingActive: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _swipeCubit),
          BlocProvider.value(value: _pageCubit),
          
        ],
        child: BlocListener<SwipeCubit<MovieResp>, SwipeState<MovieResp>>(
          listenWhen: (p, c) => p.shouldLoadMore != c.shouldLoadMore,
          listener: (context, state) {
            if (state.shouldLoadMore) {
              context.read<LoadingCubit>().show();
              _pageCubit.loadMoreMovies(context);
            }
          },
          child: BlocListener<SwipeToDecideCubit, SwipeToDecideState>(
            listener: (context, state) {
              if (!state.isLoading) {
                context.read<LoadingCubit>().hide();
                _swipeCubit.addItems(state.movies);
              }
            },
            child: TinderEnvironment<MovieResp>(
              cardHeightRatio: 0.83,
              bottomPadding: 80,
              getColor: (m) => Colors.black,
              getImage: (m) => Image.network(
                _imageBaseUrl + m.poster_path!,
                fit: BoxFit.fill,
              ),
              getTitle: (m) => "",
              getSubtitle: (m) => "",
              getDescription: (m) =>  "",
            ),
          ),
        ),
      ),
    );
  }
}
