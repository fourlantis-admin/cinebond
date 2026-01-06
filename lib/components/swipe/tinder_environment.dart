import 'package:cinebond/components/buttons/tinder_button.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
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

class TinderEnvironment<T> extends StatelessWidget {
  TinderEnvironment({
    super.key,
    required this.getColor,
    required this.getImage,
    required this.getTitle,
    required this.getSubtitle,
    required this.getDescription,
    this.cardHeightRatio = 0.9,
    this.bottomPadding = 20,
  });

  final Color Function(T) getColor;
  final Widget Function(T) getImage;
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
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: cardHeight,
                  width: constraints.maxWidth,
                  child: _buildCards(context, state),
                ),

                Positioned(
                  bottom: bottomPadding,
                  left: 45,
                  right: 45,
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

    return Positioned.fill(
      child: GestureDetector(
        onPanUpdate: isTop ? (d) => cubit.onPanUpdate(d, context) : null,
        onPanEnd: isTop ? (d) => cubit.onPanEnd(d, context) : null,
        child: Transform(
          transform: Matrix4.identity()
            ..translate(
              isTop ? cubit.state.cardOffset.dx : 0.0,
              isTop ? cubit.state.cardOffset.dy : 0.0,
              0.0,
            )
            ..rotateZ(isTop ? cubit.state.rotation : 0.0),
          child: _cardContent(item, context, isTop),
        ),
      ),
    );
  }

  Widget _cardContent(T item, BuildContext ctx, bool top) {
    final cubit = ctx.watch<SwipeCubit<T>>();
    final opacity = cubit.state.swipeOpacity;
    final dx = cubit.state.cardOffset.dx;

    return Stack(
      children: [
        /// CARD
        Container(
          decoration: BoxDecoration(
            color: getColor(item),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.expand(child: getImage(item)),
          ),
        ),

        if (top && dx < 0)
          Positioned(
            top: 40,
            left: 10,
            child: Opacity(
              opacity: opacity,
              child: _swipeLabel("NOPE", Colors.red),
            ),
          ),

        if (top && dx > 0)
          Positioned(
            top: 40,
            right: 10,
            child: Opacity(
              opacity: opacity,
              child: _swipeLabel("LIKE", Colors.green),
            ),
          ),

        if (top)
          Positioned(
            bottom: 70,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTitle(item),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  getSubtitle(item),
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  getDescription(item),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _swipeLabel(String text, Color color) {
    return Transform.rotate(
      angle: text == "NOPE" ? -0.15 : 0.15,
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

  Widget _buildButtons(BuildContext context) {
    final cubit = context.read<SwipeCubit<T>>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TinderButton(
          onClickBtnFunc: () => cubit.undoSwipe(context),
          icon: SvgPicture.asset(
            ImagesIcons.RETURN_ICON,
            color: AppColor.YELLOW,
          ),
        ),
        TinderButton(
          onClickBtnFunc: cubit.swipeLeft,
          icon: SvgPicture.asset(
            ImagesIcons.DISLIKE_ICON,
            color: AppColor.RED,
          ),
        ),
        TinderButton(
          onClickBtnFunc: cubit.swipeRight,
          icon: SvgPicture.asset(
            ImagesIcons.LIKE_ICON,
            color: AppColor.GREEN,
          ),
        ),
      ],
    );
  }
}
