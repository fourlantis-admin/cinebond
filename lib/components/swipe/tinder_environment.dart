import 'package:cinebond/components/buttons/tinder_button.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile {
  final String nameAge;
  final String occupation;
  final String interests;
  final Color color;
  final Widget picture;
  Profile({
    required this.nameAge,
    required this.occupation,
    required this.interests,
    required this.color,
    required this.picture,
  });
}

class TinderEnvironment extends StatelessWidget {
  const TinderEnvironment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeCubit, SwipeState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardHeight = constraints.maxHeight * 0.8;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: cardHeight,
                  width: constraints.maxWidth,
                  child: _buildCards(context, state),
                ),

                /// BUTONLAR
                _buildButtons(context),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCards(BuildContext context, SwipeState state) {
    return Stack(
      children: state.profiles
          .asMap()
          .entries
          .take(4)
          .map((entry) => _buildCard(context, entry.key, entry.value))
          .toList()
          .reversed
          .toList(),
    );
  }

  Widget _buildCard(BuildContext context, int index, Profile profile) {
    final cubit = context.read<SwipeCubit>();

    final isTop = index == 0;
    final scale = 1 - (index * 0.05);
    final verticalOffset = index * 10.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      left: 0,
      right: 0,
      top: verticalOffset,
      bottom: -verticalOffset,
      child: Transform.scale(
        scale: isTop ? 1 : scale,
        child: isTop
            ? GestureDetector(
                onPanUpdate: (d) => cubit.onPanUpdate(d, context),
                onPanEnd: (_) => cubit.onPanEnd(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()
                    ..translate(
                      cubit.state.cardOffset.dx,
                      cubit.state.cardOffset.dy,
                    )
                    ..rotateZ(cubit.state.rotation),
                  child: _cardContent(profile, context, true),
                ),
              )
            : _cardContent(profile, context, false),
      ),
    );
  }

  Widget _cardContent(Profile profile, BuildContext ctx, bool top) {
    final cubit = ctx.watch<SwipeCubit>();
    final opacity = cubit.state.swipeOpacity;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: profile.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.expand(
              child: FittedBox(fit: BoxFit.cover, child: profile.picture),
            ),
          ),
        ),

        if (top)
          Positioned(
            top: 40,
            left: 20,
            child: Opacity(
              opacity: cubit.state.cardOffset.dx < 0 ? opacity : 0,
              child: _swipeLabel("NOPE", Colors.red),
            ),
          ),

        if (top)
          Positioned(
            top: 40,
            right: 20,
            child: Opacity(
              opacity: cubit.state.cardOffset.dx > 0 ? opacity : 0,
              child: _swipeLabel("LIKE", Colors.green),
            ),
          ),

        Positioned(
          bottom: 70,
          left: 20,
          child: _buildSwipeCard(profile),
        ),
      ],
    );
  }

  Widget _swipeLabel(String text, Color color) {
    return Transform.rotate(
      angle: text == "NOPE" ? -0.25 : 0.25,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 58,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCard(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.nameAge,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        VerticalSpacing(5),
        Text(profile.occupation,
            style: const TextStyle(color: Colors.white70)),
        VerticalSpacing(5),
        Text(profile.interests,
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final cubit = context.read<SwipeCubit>();

    return Positioned(
      bottom: 110,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TinderButton(
            onClickBtnFunc: () {},
            icon: SvgPicture.asset(ImagesIcons.RETURN_ICON),
          ),
          TinderButton(
            onClickBtnFunc: () => cubit.swipeLeft(),
            icon: SvgPicture.asset(ImagesIcons.DISLIKE_ICON),
          ),
          TinderButton(
            onClickBtnFunc: () => cubit.swipeRight(),
            icon: SvgPicture.asset(ImagesIcons.LIKE_ICON),
          ),
        ],
      ),
    );
  }
}
