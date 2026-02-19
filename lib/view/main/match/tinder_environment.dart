import 'dart:ui';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/components/swipe/empty_state.dart';
import 'package:cinebond/components/swipe/interest_pills.dart';
import 'package:cinebond/components/swipe/round_button.dart';
import 'package:cinebond/components/swipe/stamp_label.dart';
import 'package:cinebond/components/swipe/verified_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
class Profile {
  final String nameAge;
  final String occupation;
  final String interests;
  final Color color;
  final String? horoscope;
  final List<Widget> pictures;

  Profile({
    required this.nameAge,
    required this.occupation,
    required this.interests,
    required this.color,
    required this.pictures,
    this.horoscope,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  TINDER ENVIRONMENT  –  birebir aynı parametre imzası, Bumble kalitesi UI
// ─────────────────────────────────────────────────────────────────────────────

class TinderEnvironment<T> extends StatelessWidget {
   TinderEnvironment({
    super.key,
    required this.getColor,
    required this.getTitle,
    required this.getSubtitle,
    required this.getDescription,
    this.cardHeightRatio = 0.9,
    this.bottomPadding = 40,
    this.onEmpty,
  });

  /// Orijinal parametre isimleri korundu ↓
  final Color Function(T) getColor;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final String Function(T) getDescription; // interests string → pill'e çevrilir
  final double cardHeightRatio;
  final double bottomPadding;
  final Widget? onEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeCubit<T>, SwipeState<T>>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return onEmpty ??  EmptyState();
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardH = constraints.maxHeight * cardHeightRatio;
            return Stack(
              children: [
                SizedBox(
                  height: cardH,
                  width: constraints.maxWidth,
                  child: CardStack<T>(
                    constraints: constraints,
                    getTitle: getTitle,
                    getSubtitle: getSubtitle,
                    getDescription: getDescription,
                    getColor: getColor,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: ActionRow<T>(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


class CardStack<T> extends StatelessWidget {
   CardStack({
    required this.constraints,
    required this.getTitle,
    required this.getSubtitle,
    required this.getDescription,
    required this.getColor,
  });

  final BoxConstraints constraints;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final String Function(T) getDescription;
  final Color Function(T) getColor;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SwipeCubit<T>>().state;
    final visible = state.items.take(3).toList();

    return Stack(
      children: visible
          .asMap()
          .entries
          .map((e) => _buildCard(context, e.key, e.value, state))
          .toList()
          .reversed
          .toList(),
    );
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    T item,
    SwipeState<T> state,
  ) {
    final cubit = context.read<SwipeCubit<T>>();
    final isTop = index == 0;

    final progress = (state.cardOffset.dx.abs() / 200).clamp(0.0, 1.0);
    final backScale = isTop
        ? 1.0
        : lerpDouble(0.94 - index * 0.025, 1.0, progress)!;
    final backDY =
        isTop ? 0.0 : lerpDouble(index * 14.0, 0.0, progress)!;

    final dx = isTop ? state.cardOffset.dx : 0.0;
    final dy = isTop ? state.cardOffset.dy : backDY;
    final rot = isTop ? state.rotation : 0.0;

    final cardKey = GlobalKey<SwipeCardState<T>>();

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: isTop
            ? (d) {
                final box = context.findRenderObject() as RenderBox;
                final lx = box.globalToLocal(d.globalPosition).dx;
                if (lx > constraints.maxWidth / 2) {
                  cardKey.currentState?.next();
                } else {
                  cardKey.currentState?.prev();
                }
              }
            : null,
        onPanUpdate: isTop ? (d) => cubit.onPanUpdate(d, context) : null,
        onPanEnd: isTop ? (d) => cubit.onPanEnd(d, context) : null,
        child: AnimatedContainer(
          duration: state.isAnimating && isTop
              ?  Duration(milliseconds: 380)
              : Duration.zero,
          curve: Curves.easeOutQuart,
          transform: Matrix4.identity()
            ..translate(dx, dy)
            ..rotateZ(rot)
            ..scale(backScale),
          transformAlignment: Alignment.center,
          child: SwipeCard<T>(
            key: cardKey,
            item: item,
            isTop: isTop,
            getTitle: getTitle,
            getSubtitle: getSubtitle,
            getDescription: getDescription,
            getColor: getColor,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SWIPE CARD
// ─────────────────────────────────────────────────────────────────────────────

class SwipeCard<T> extends StatefulWidget {
   SwipeCard({
    super.key,
    required this.item,
    required this.isTop,
    required this.getTitle,
    required this.getSubtitle,
    required this.getDescription,
    required this.getColor,
  });

  final T item;
  final bool isTop;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final String Function(T) getDescription;
  final Color Function(T) getColor;

  @override
  State<SwipeCard<T>> createState() => SwipeCardState<T>();
}

class SwipeCardState<T> extends State<SwipeCard<T>> {
  final _photoIndex = ValueNotifier<int>(0);

  List<Widget> get _pictures {
    final item = widget.item;
    if (item is Profile) return item.pictures;
    return [];
  }

  void next() {
    if (_photoIndex.value < _pictures.length - 1) _photoIndex.value++;
  }

  void prev() {
    if (_photoIndex.value > 0) _photoIndex.value--;
  }

  @override
  void dispose() {
    _photoIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SwipeCubit<T>>().state;
    final dx = widget.isTop ? state.cardOffset.dx : 0.0;
    final pictures = _pictures;
    final accent = widget.getColor(widget.item);

    // Stamp opacity
    final likeOpacity = (dx / 100).clamp(0.0, 1.0);
    final nopeOpacity = (-dx / 100).clamp(0.0, 1.0);
    final superOpacity = widget.isTop &&
            state.activeDirection == SwipeDirection.up
        ? 1.0
        : 0.0;

    // interests string → liste
    final rawDesc = widget.getDescription(widget.item);
    final tags = rawDesc
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (pictures.isNotEmpty)
            ValueListenableBuilder<int>(
              valueListenable: _photoIndex,
              builder: (_, idx, __) => AnimatedSwitcher(
                duration:  Duration(milliseconds: 220),
                child: SizedBox.expand(
                  key: ValueKey(idx),
                  child: pictures[idx],
                ),
              ),
            )
          else
            ColoredBox(color: accent.withOpacity(0.4)),

          if (pictures.length > 1)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: ValueListenableBuilder<int>(
                valueListenable: _photoIndex,
                builder: (_, idx, __) => Row(
                  children: List.generate(pictures.length, (i) {
                    return Expanded(
                      child: AnimatedContainer(
                        duration:  Duration(milliseconds: 200),
                        height: 3.5,
                        margin:  EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: i == idx
                              ? Colors.white
                              : Colors.white.withOpacity(0.35),
                          boxShadow: i == idx
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

           Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 0.7, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0x88000000),
                    Color(0xDD000000),
                  ],
                ),
              ),
            ),
          ),

          // ── Profil bilgisi ──
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.getTitle(widget.item),
                        style:  TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black54)
                          ],
                        ),
                      ),
                    ),
                    VerifiedBadge(),
                  ],
                ),
                VerticalSpacing( 4),
                Text(
                  widget.getSubtitle(widget.item),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                if (tags.isNotEmpty) ...[
                  VerticalSpacing( 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: tags
                        .take(4)
                        .map((t) => InterestPill(label: t, accent: accent))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),

          // ── LIKE stamp ──
          Positioned(
            top: 56,
            left: 20,
            child: AnimatedOpacity(
              opacity: likeOpacity,
              duration: Duration.zero,
              child: Transform.rotate(
                angle: -0.3,
                child: StampLabel(label: 'LIKE', color:  Color(0xFF00E676)),
              ),
            ),
          ),

          // ── NOPE stamp ──
          Positioned(
            top: 56,
            right: 20,
            child: AnimatedOpacity(
              opacity: nopeOpacity,
              duration: Duration.zero,
              child: Transform.rotate(
                angle: 0.3,
                child: StampLabel(label: 'NOPE', color:  Color(0xFFFF1744)),
              ),
            ),
          ),

          // ── SUPER LIKE stamp ──
          Positioned(
            top: 56,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: superOpacity,
              duration:  Duration(milliseconds: 100),
              child:  Center(
                child: StampLabel(
                  label: 'SUPER\nLIKE',
                  color: Color(0xFF2979FF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ACTION ROW
// ─────────────────────────────────────────────────────────────────────────────

class ActionRow<T> extends StatelessWidget {
   ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SwipeCubit<T>>();
    final hasUndo =
        context.watch<SwipeCubit<T>>().state.lastSwipedItem != null;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RoundButton(
            onTap: cubit.swipeLeft,
            icon: Icons.close_rounded,
            color:  Color(0xFFFF4B6E),
            size: 64,
            iconSize: 45,
            glowColor:  Color(0x44FF4B6E),
          ),
          RoundButton(
            onTap: hasUndo ? () => cubit.undoSwipe(context) : null,
            icon: Icons.replay_rounded,
            color: hasUndo ?  Color(0xFFFFB300) : Colors.grey.shade300,
            size: 50,
            iconSize: 30,
            glowColor:
                hasUndo ?  Color(0x44FFB300) : Colors.transparent,
          ),
          RoundButton(
            onTap: cubit.swipeSuperLike,
            icon: Icons.star_rounded,
            color:  Color(0xFF2979FF),
            size: 50,
            iconSize: 30,
            glowColor:  Color(0x442979FF),
          ),
          RoundButton(
            onTap: cubit.swipeRight,
            icon: Icons.favorite_rounded,
            color:  Color(0xFF00E676),
            size: 64,
            iconSize: 45,
            glowColor:  Color(0x4400E676),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────


