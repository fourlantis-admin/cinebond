
import 'package:cinebond/components/swipe/match_pill.dart';
import 'package:cinebond/controller/swipe/swipe_cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/main/match/tinder_environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      );
    }).toList();
  }
}
