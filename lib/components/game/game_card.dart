import 'package:cinebond/components/game/pill_badge.dart';
import 'package:cinebond/controller/game/game_cubit.dart';
import 'package:cinebond/models/game/game_models.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/main/play/game_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameCard extends StatefulWidget {
  final GameCardData data;

  const GameCard({required this.data});

  @override
  State<GameCard> createState() => GameCardState();
}

class GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        final cubit = context.read<GamesCubit>();
        // startGame'i BURADAN kaldırdık, GamePlayScreen'in initState'inde çağrılacak

        Navigator.of(context)
            .push(
              PageRouteBuilder(
                pageBuilder: (ctx, anim, _) => BlocProvider.value(
                  value: cubit,
                  child: GamePlayScreen(gameType: d.type),
                ),
                transitionsBuilder: (ctx, anim, _, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              ),
            )
            .then((_) => cubit.backToLobby());
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (ctx, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: d.gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: d.accent.withOpacity(0.25)),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: d.accent.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(d.icon, style: const TextStyle(fontSize: 56)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(d.icon, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 10),
                        Text(d.title),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.subtitle),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            PillBadge(label: d.difficulty, color: d.accent),
                            const SizedBox(width: 8),
                            PillBadge(
                              label: '🍿 ${d.points}',
                              color: AppColor.MAIN_PURPLE,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
