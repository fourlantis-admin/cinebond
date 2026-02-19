import 'package:cinebond/components/feed/post/post_model_card.dart';
import 'package:cinebond/components/glass-container/glass_container.dart';
import 'package:cinebond/components/movie/movie_poster_item.dart';
import 'package:cinebond/components/story-board/story_board.dart';
import 'package:cinebond/controller/explore/explore_cubit.dart';
import 'package:cinebond/controller/movie/favorites_cubit.dart';
import 'package:cinebond/models/movie/movie_question_model.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/view/main/explore/swipe_to_decide_view.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// Feed Model
// ---------------------------------------------------------------------------

class PostModel {
  final String username;
  final String handle;
  final String avatarUrl;
  final String content;
  final String? moviePosterUrl;
  final String? movieTitle;
  final int likes;
  final int comments;
  final int reposts;
  final String timeAgo;
  final String type;
  bool isLiked;
  bool isReposted;

  PostModel({
    required this.username,
    required this.handle,
    required this.avatarUrl,
    required this.content,
    required this.type,
    this.moviePosterUrl,
    this.movieTitle,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.timeAgo,
    this.isLiked = false,
    this.isReposted = false,
  });
}

// ---------------------------------------------------------------------------
// ExploreView
// ---------------------------------------------------------------------------

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late final ExploreCubit _exploreCubit;
  late final FavoritesCubit _favoritesCubit;
  late final List<PostModel> _postModels;

  // Scroll kontrolü
  final ScrollController _scrollController = ScrollController();

  // Scroll-to-top butonu görünür mü?
  bool _showScrollTop = false;

  // Buton animasyonu için
  static const double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    final repo = MovieRepository();
    _exploreCubit = ExploreCubit(repo: repo)..getMovies(context);
    _favoritesCubit = FavoritesCubit(movieRepository: repo);
    _postModels = _buildMockFeed();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > _scrollThreshold;
    if (shouldShow != _showScrollTop) {
      setState(() => _showScrollTop = shouldShow);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  List<PostModel> _buildMockFeed() => [
    PostModel(
      username: "Ayşe K.",
      handle: "@aysek",
      avatarUrl: "https://i.pravatar.cc/150?img=47",
      content:
          "Inception'ı dün tekrar izledim. Her seferinde ayrı bir şey keşfediyorum 🎬🔥",
      moviePosterUrl:
          "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg",
      movieTitle: "Inception",
      likes: 142,
      comments: 23,
      reposts: 31,
      timeAgo: "2s",
      type: "Film",
    ),
    PostModel(
      username: "Mert D.",
      handle: "@mertd",
      avatarUrl: "https://i.pravatar.cc/150?img=12",
      content:
          "Oppenheimer gerçekten master piece. Nolan bir kez daha kendini aştı 👏",
      moviePosterUrl:
          "https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg",
      movieTitle: "Oppenheimer",
      likes: 389,
      comments: 57,
      reposts: 102,
      timeAgo: "45dk",
      type: "Film",
    ),
    PostModel(
      username: "Selin Y.",
      handle: "@seliny",
      avatarUrl: "https://i.pravatar.cc/150?img=32",
      content:
          "Bu hafta sonu film önerisi: Parasite. İzlemediyseniz kaçırmayın! 🏆",
      likes: 74,
      comments: 18,
      reposts: 22,
      timeAgo: "2sa",
      type: "Film",
    ),
    PostModel(
      username: "Burak A.",
      handle: "@buraka",
      avatarUrl: "https://i.pravatar.cc/150?img=60",
      content:
          "The Dark Knight senaryosu hâlâ eşsiz. Heath Ledger'ın Joker'i unutulmaz 🃏",
      moviePosterUrl:
          "https://ntvb.tmsimg.com/assets/p15791706_v_h8_ai.jpg?w=1280&h=720",
      movieTitle: "The Dark Knight",
      likes: 512,
      comments: 89,
      reposts: 201,
      timeAgo: "5sa",
      type: "Film",
    ),
    PostModel(
      username: "Zeynep T.",
      handle: "@zeynept",
      avatarUrl: "https://i.pravatar.cc/150?img=25",
      content:
          "Interstellar'daki veri analizi sahnesi beni her seferinde büyülüyor ✨",
      likes: 233,
      comments: 44,
      reposts: 67,
      timeAgo: "1g",
      type: "Film",
    ),
    PostModel(
      username: "Kaan M.",
      handle: "@kaanm",
      avatarUrl: "https://i.pravatar.cc/150?img=8",
      content:
          "Whiplash izleyen var mı? Finaldeki sahne adrenalini patlatıyor 🥁",
      likes: 198,
      comments: 34,
      reposts: 55,
      timeAgo: "2g",
      type: "Film",
    ),
    PostModel(
      username: "Nisan E.",
      handle: "@nisane",
      avatarUrl: "https://i.pravatar.cc/150?img=15",
      content: "Her yıl izlediğim film: La La Land 💫 Bazı şeyler değişmiyor.",
      moviePosterUrl:
          "https://image.tmdb.org/t/p/w500/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg",
      movieTitle: "La La Land",
      likes: 321,
      comments: 61,
      reposts: 88,
      timeAgo: "3g",
      type: "Film",
    ),
    PostModel(
      username: "Emre S.",
      handle: "@emres",
      avatarUrl: "https://i.pravatar.cc/150?img=33",
      content:
          "Parasite'ı Güney Kore sineması adına bir dönüm noktası olarak görüyorum 🎌",
      likes: 415,
      comments: 72,
      reposts: 130,
      timeAgo: "4g",
      type: "Film",
    ),
  ];

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _exploreCubit.close();
    _favoritesCubit.close();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _exploreCubit),
        BlocProvider.value(value: _favoritesCubit),
      ],
      child: Stack(
        children: [
          // ── Ana içerik ───────────────────────────────────────────────────
          _buildExpandedLayout(),
          // ── Scroll-to-top butonu ─────────────────────────────────────────
          _buildScrollToTopButton(),
        ],
      ),
    );
  }
  // =========================================================================
  // Expanded layout — tek ScrollView, tüm içerik + sonsuz feed
  // =========================================================================

  Widget _buildExpandedLayout() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoryBoard(context),
          VerticalSpacing(12),
          _buildGamesRow(context),
          VerticalSpacing(16),
          _buildTrendingSection(context),
          VerticalSpacing(16),
          _buildFeedSection(isExpanded: true),
        ],
      ),
    );
  }

  // =========================================================================
  // Storyboard
  // =========================================================================

  Widget _buildStoryBoard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Storyboard",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpacing(10),
        SizedBox(height: 60, child: StoryBoard(storyCount: 6)),
      ],
    );
  }

  // =========================================================================
  // Games Row
  // =========================================================================

  Widget _buildGamesRow(BuildContext context) {
    final List<MovieQuestionModel> images = [
      MovieQuestionModel(
        image:
            "https://ntvb.tmsimg.com/assets/p15791706_v_h8_ai.jpg?w=1280&h=720",
        titleSmall: "Günün Sorusu:",
        titleLarge: "Hangi film?",
        optionLeft: "Soruyu çöz puanını kazan!",
        optionRight: "250 pts",
      ),
      MovieQuestionModel(
        image:
            "https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg",
        titleSmall: "Günün Sorusu:",
        titleLarge: "Hangi aktör?",
        optionLeft: "Soruyu çöz puanını kazan!",
        optionRight: "150 pts",
      ),
      MovieQuestionModel(
        image:
            "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg",
        titleSmall: "Günün Sorusu:",
        titleLarge: "Hangi yönetmen?",
        optionLeft: "Soruyu çöz puanını kazan!",
        optionRight: "50 pts",
      ),
    ];

    return SizedBox(
      height: 145,
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
            child: GlassContainer(
              image: NetworkImage(images[index].image ?? ""),
              titleSmall: images[index].titleSmall ?? "",
              titleLarge: images[index].titleLarge ?? "",
              optionLeft: images[index].optionLeft ?? "",
              optionRight: images[index].optionRight ?? "",
            ),
          );
        },
        separatorBuilder: (_, __) => HorizontalSpacing(3),
      ),
    );
  }

  // =========================================================================
  // Trending
  // =========================================================================

  Widget _buildTrendingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trending",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpacing(12),
        SizedBox(
          height: 165,
          child: BlocSelector<ExploreCubit, ExploreState, List<MovieResp>>(
            selector: (state) => state.filteredMovies,
            builder: (context, movies) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                separatorBuilder: (_, __) => HorizontalSpacing(8),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return SizedBox(
                    width: 110,
                    child: MoviePosterItem(
                      key: ValueKey(movie.id),
                      movie: movie,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Feed Section
  // =========================================================================

  Widget _buildFeedSection({required bool isExpanded}) {
    final header = Row(
      children: [
        Text(
          "Feed",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    final list = ListView.separated(
      shrinkWrap: true,
      physics: isExpanded
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      itemCount: _postModels.length,
      separatorBuilder: (_, __) =>
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
      itemBuilder: (context, index) {
        return PostModelCard(
          post: _postModels[index],
          onLike: () => setState(() {
            _postModels[index].isLiked = !_postModels[index].isLiked;
          }),
          onRepost: () => setState(() {
            _postModels[index].isReposted = !_postModels[index].isReposted;
          }),
        );
      },
    );

    if (isExpanded) {
      // Expanded modda Column yeterli
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, VerticalSpacing(12), list, VerticalSpacing(32)],
      );
    }

    // Normal modda Expanded + içi Column ile scroll alanı kaplar
    return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              VerticalSpacing(12),
              Expanded(child: list),
            ],
          ),
        )
        as Widget;
  }

  // =========================================================================
  // Scroll-to-top butonu
  // =========================================================================

  Widget _buildScrollToTopButton() {
    return Positioned(
      // Ekranın üst ortasında, safe area'ya göre konumlanır
      top: MediaQuery.of(context).padding.top + 12,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showScrollTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: AnimatedSlide(
          offset: _showScrollTop ? Offset.zero : const Offset(0, -0.5),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: Center(
            child: GestureDetector(
              onTap: _showScrollTop ? _scrollToTop : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFFE91E8C).withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animasyonlu ok ikonu
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: _showScrollTop ? 1.0 : 0.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.7 + (0.3 * value),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E8C), Color(0xFF9C27B0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
