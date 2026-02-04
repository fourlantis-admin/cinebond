import 'package:cinebond/components/buttons/tinder_button.dart';
import 'package:cinebond/components/swipe/match_pill.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Profile {
  final String nameAge;
  final String occupation;
  final String interests;
  final Color color;

  final List<Widget> pictures;

  Profile({
    required this.nameAge,
    required this.occupation,
    required this.interests,
    required this.color,
    required this.pictures,
  });
}

class TinderEnvironment<T> extends StatelessWidget {
  TinderEnvironment({
    super.key,
    required this.getColor,
    required this.getTitle,
    required this.getSubtitle,
    required this.getDescription,
    this.cardHeightRatio = 0.9,
    this.bottomPadding = 20,
  });

  final Color Function(T) getColor;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final String Function(T) getDescription;

  final double cardHeightRatio;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeCubit<T>, SwipeState<T>>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardHeight = constraints.maxHeight * cardHeightRatio;

            return Stack(
              children: [
                SizedBox(
                  height: cardHeight,
                  width: constraints.maxWidth,
                  child: _buildCards(context, state),
                ),

                /// BOTTOM BUTTONS
                Positioned(
                  bottom: 20,
                  left: 40,
                  right: 40,
                  child: _buildButtons(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCards(BuildContext context, SwipeState<T> state) {
    return Stack(
      children: state.items
          .take(4)
          .toList()
          .asMap()
          .entries
          .map((e) => _buildCard(context, e.key, e.value))
          .toList()
          .reversed
          .toList(),
    );
  }

  Widget _buildCard(BuildContext context, int index, T item) {
    final cubit = context.read<SwipeCubit<T>>();
    final isTop = index == 0;
    final cardKey = GlobalKey<_ProfileCardState>();

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapUp: (details) {
          if (!isTop) return;

          final box = context.findRenderObject() as RenderBox;
          final localX = box.globalToLocal(details.globalPosition).dx;
          final width = box.size.width;

          final state = cardKey.currentState;
          if (state == null) return;

          if (localX > width / 2) {
            state.next();
          } else {
            state.prev();
          }
        },
        onPanUpdate: isTop ? (d) => cubit.onPanUpdate(d, context) : null,
        onPanEnd: isTop ? (d) => cubit.onPanEnd(d, context) : null,

        child: Transform(
          transform: Matrix4.identity()
            ..setTranslationRaw(
              isTop ? cubit.state.cardOffset.dx : 0.0,
              isTop ? cubit.state.cardOffset.dy : 0.0,
              0.0,
            )
            ..rotateZ(isTop ? cubit.state.rotation : 0),
          child: ProfileCard(
            key: cardKey,
            profile: item as Profile,
            isTop: isTop,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final cubit = context.read<SwipeCubit<T>>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TinderButton(
          customColor: AppColor.TINDER_BUTTON_COLOR,
          onClickBtnFunc: cubit.swipeLeft,
          icon: SvgPicture.asset(ImagesIcons.DISLIKE_ICON,color: Colors.white,),
        ),
        TinderButton(
          customColor: AppColor.TINDER_BUTTON_COLOR,
          onClickBtnFunc: () => cubit.undoSwipe(context),
          icon: SvgPicture.asset(ImagesIcons.RETURN_ICON,color: Colors.white,),
          btnHeight: 60,
          btnWidth: 60,
        ),
        TinderButton(
          customColor: AppColor.TINDER_BUTTON_COLOR,
          onClickBtnFunc: cubit.swipeRight,
          icon: SvgPicture.asset(ImagesIcons.LIKE_ICON,color: Colors.white),
        ),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final bool isTop;

  const ProfileCard({super.key, required this.profile, required this.isTop});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final ValueNotifier<int> photoIndex = ValueNotifier<int>(0);

  static const Color _inactiveIcon = Color(0x66FFFFFF);

  void next() {
    if (photoIndex.value < widget.profile.pictures.length - 1) {
      photoIndex.value++;
    }
  }

  void prev() {
    if (photoIndex.value > 0) {
      photoIndex.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SwipeCubit<Profile>>();
    final dx = cubit.state.cardOffset.dx;

    final liking = dx > 20;
    final disliking = dx < -20;

    return Stack(
      children: [
        /// FOTO
        ValueListenableBuilder<int>(
          valueListenable: photoIndex,
          builder: (_, index, __) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: SizedBox.expand(child: widget.profile.pictures[index]),
            );
          },
        ),

        Positioned(top: 25, left: 0, right: 0, child: MatchPill()),

        /// FOTO BAR
        Positioned(
          top: 14,
          left: 16,
          right: 16,
          child: ValueListenableBuilder<int>(
            valueListenable: photoIndex,
            builder: (_, index, __) {
              return Row(
                children: List.generate(
                  widget.profile.pictures.length,
                  (i) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: i == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        /// GRADIENT
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),
        ),

        /// ❌
        Positioned(
          left: 12,
          top: 0,
          bottom: 0,
          child: Center(child: _sideActionIcon(Icons.close_rounded, disliking)),
        ),

        /// ❤️
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(child: _sideActionIcon(Icons.favorite_rounded, liking)),
        ),

        Positioned(
          bottom: 88,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.nameAge,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: _buildInterestPills(
                  widget.profile.occupation,
                  widget.profile.interests,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sideActionIcon(IconData icon, bool active) {
    return ClipOval(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(
          icon,
          size: 36,
          color: active ? Colors.white : _inactiveIcon,
        ),
      ),
    );
  }

  List<Widget> _buildInterestPills(String subtitle, String description) {
    final interests = [
      subtitle,
      ...description.split(',').map((e) => e.trim()),
    ];

    return interests.map((text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppColor.NEON_PURPLE.withOpacity(0.9),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      );
    }).toList();
  }
}
