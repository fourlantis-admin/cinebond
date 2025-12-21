import 'package:cinebond/components/swipe/tinder_environment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SwipeState {
  final List profiles;
  final Offset cardOffset;
  final double rotation;
  final double swipeOpacity;
  final bool shouldLoadMore;
  final int currentIndex;

  SwipeState({
    required this.profiles,
    this.cardOffset = Offset.zero,
    this.rotation = 0,
    this.swipeOpacity = 0,
    this.shouldLoadMore = false,
    this.currentIndex = 0,
  });

  SwipeState copyWith({
    List? profiles,
    Offset? cardOffset,
    double? rotation,
    double? swipeOpacity,
    bool? shouldLoadMore,
    int? currentIndex,
  }) {
    return SwipeState(
      profiles: profiles ?? this.profiles,
      cardOffset: cardOffset ?? this.cardOffset,
      rotation: rotation ?? this.rotation,
      swipeOpacity: swipeOpacity ?? this.swipeOpacity,
      shouldLoadMore: shouldLoadMore ?? this.shouldLoadMore,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class SwipeCubit extends Cubit<SwipeState> {
  SwipeCubit({required List profiles}) : super(SwipeState(profiles: profiles));

  final double swipeThreshold = 100;
  final double rotationMax = pi / 10;

  void swipeRight() {
    _swipeLogic(const Offset(2000, -450), rotationMax, removeCard: true);
  }

  void swipeLeft() {
    _swipeLogic(const Offset(-2000, -450), -rotationMax, removeCard: true);
  }

  void addProfiles(List<Profile> newOnes) {
    final updated = List.of(state.profiles)..addAll(newOnes);
    emit(state.copyWith(profiles: updated, shouldLoadMore: false));
  }

  void _swipeLogic(Offset target, double rotation, {bool removeCard = false}) {
    bool isLike = rotation > 0;

    emit(
      state.copyWith(
        cardOffset: target,
        rotation: rotation, //rotation + ise likelamış eksi ise nopelamış
        swipeOpacity: 0,
      ),
    );
    print(state);
    Future.delayed(const Duration(milliseconds: 50), () {
      if (removeCard && state.profiles.isNotEmpty) {
        print(state.profiles[0]);
        final updated = List.of(state.profiles)..removeAt(0);
        print(isLike);
        bool loadMore = updated.isEmpty;
        emit(
          state.copyWith(
            profiles: updated,
            cardOffset: Offset.zero,
            rotation: 0,
            shouldLoadMore: loadMore,
          ),
        );
      } else {
        emit(state.copyWith(cardOffset: Offset.zero, rotation: 0));
      }
    });
  }

  void onPanUpdate(DragUpdateDetails d, BuildContext ctx) {
    final newOffset = state.cardOffset + d.delta;

    final dragRatio = newOffset.dx / MediaQuery.of(ctx).size.width;
    final rotation = (rotationMax * dragRatio).clamp(-rotationMax, rotationMax);

    final opacity = (newOffset.dx.abs() / (swipeThreshold * 2.5)).clamp(
      0.0,
      1.0,
    );

    emit(
      state.copyWith(
        cardOffset: newOffset,
        rotation: rotation,
        swipeOpacity: opacity,
      ),
    );
  }

  void onPanEnd() {
    final dx = state.cardOffset.dx;

    if (dx.abs() > swipeThreshold) {
      final targetX = dx > 0 ? 2000.0 : -2000.0;
      final targetRotation = dx > 0 ? rotationMax : -rotationMax;

      _swipeLogic(
        Offset(targetX, state.cardOffset.dy),
        targetRotation,
        removeCard: true,
      );
    } else {
      _swipeLogic(Offset.zero, 0);
    }
  }
}
