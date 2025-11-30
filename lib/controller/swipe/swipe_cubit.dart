import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SwipeCubit extends Cubit<SwipeState> {
  SwipeCubit({required List profiles})
      : super(SwipeState(profiles: profiles));

  final double swipeThreshold = 100;
  final double rotationMax = pi / 10;

  void onPanUpdate(DragUpdateDetails d, BuildContext ctx) {
    final newOffset = state.cardOffset + d.delta;

    final dragRatio = newOffset.dx / MediaQuery.of(ctx).size.width;
    final rotation = (rotationMax * dragRatio)
        .clamp(-rotationMax, rotationMax);

    final opacity = (newOffset.dx.abs() / (swipeThreshold * 2.5))
        .clamp(0.0, 1.0);

    emit(state.copyWith(
      cardOffset: newOffset,
      rotation: rotation,
      swipeOpacity: opacity,
    ));
  }

  void onPanEnd() {
    final dx = state.cardOffset.dx;

    if (dx.abs() > swipeThreshold) {
      final targetX = dx > 0 ? 2000.0 : -2000.0;
      final targetRotation = dx > 0 ? rotationMax : -rotationMax;

      _animateTo(
        Offset(targetX, state.cardOffset.dy),
        targetRotation,
        removeCard: true,
      );
    } else {
      _animateTo(Offset.zero, 0);
    }
  }

  void _animateTo(Offset target, double rotation, {bool removeCard = false}) {
    emit(state.copyWith(
      cardOffset: target,
      rotation: rotation,
      swipeOpacity: 0,
    ));

    Future.delayed(const Duration(milliseconds: 250), () {
      if (removeCard && state.profiles.isNotEmpty) {
        final updated = List.of(state.profiles)..removeAt(0);
        emit(state.copyWith(
          profiles: updated,
          cardOffset: Offset.zero,
          rotation: 0,
        ));
      } else {
        emit(state.copyWith(
          cardOffset: Offset.zero,
          rotation: 0,
        ));
      }
    });
  }
}
class SwipeState {
  final List profiles;
  final Offset cardOffset;
  final double rotation;
  final double swipeOpacity;

  SwipeState({
    required this.profiles,
    this.cardOffset = Offset.zero,
    this.rotation = 0,
    this.swipeOpacity = 0,
  });

  SwipeState copyWith({
    List? profiles,
    Offset? cardOffset,
    double? rotation,
    double? swipeOpacity,
  }) {
    return SwipeState(
      profiles: profiles ?? this.profiles,
      cardOffset: cardOffset ?? this.cardOffset,
      rotation: rotation ?? this.rotation,
      swipeOpacity: swipeOpacity ?? this.swipeOpacity,
    );
  }
}
