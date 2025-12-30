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

  // 🔥 SADECE BUNU EKLİYORUZ
  final Profile? lastSwipedProfile;
  final bool lastSwipeWasRight;

  SwipeState({
    required this.profiles,
    this.cardOffset = Offset.zero,
    this.rotation = 0,
    this.swipeOpacity = 0,
    this.shouldLoadMore = false,
    this.currentIndex = 0,
    this.lastSwipedProfile,
    this.lastSwipeWasRight = true,
  });

  SwipeState copyWith({
    List? profiles,
    Offset? cardOffset,
    double? rotation,
    double? swipeOpacity,
    bool? shouldLoadMore,
    int? currentIndex,
    Profile? lastSwipedProfile,
    bool? lastSwipeWasRight,
  }) {
    return SwipeState(
      profiles: profiles ?? this.profiles,
      cardOffset: cardOffset ?? this.cardOffset,
      rotation: rotation ?? this.rotation,
      swipeOpacity: swipeOpacity ?? this.swipeOpacity,
      shouldLoadMore: shouldLoadMore ?? this.shouldLoadMore,
      currentIndex: currentIndex ?? this.currentIndex,
      lastSwipedProfile: lastSwipedProfile ?? this.lastSwipedProfile,
      lastSwipeWasRight: lastSwipeWasRight ?? this.lastSwipeWasRight,
    );
  }
}

class SwipeCubit extends Cubit<SwipeState> {
  SwipeCubit({required List profiles}) : super(SwipeState(profiles: profiles));

  final double swipeThreshold = 100;
  final double rotationMax = pi / 10;

  void swipeRight() =>
      _swipeLogic(Offset(2000, -450), rotationMax, removeCard: true);
  void swipeLeft() =>
      _swipeLogic(Offset(-2000, -450), -rotationMax, removeCard: true);

  void addProfiles(List<Profile> newOnes) {
    final updated = List.of(state.profiles)..addAll(newOnes);
    emit(state.copyWith(profiles: updated, shouldLoadMore: false));
  }

  void _swipeLogic(
  Offset target,
  double rotation, {
  bool removeCard = false,
}) {
  final bool isLike = rotation > 0;

  // 🔹 Swipe animasyonu (mevcut davranış)
  emit(
    state.copyWith(
      cardOffset: target,
      rotation: rotation,
      swipeOpacity: 1,
    ),
  );

  Future.delayed(const Duration(milliseconds: 450), () {
    if (removeCard && state.profiles.isNotEmpty) {
      final swipedProfile = state.profiles.first; // 🔥 HATIRLA
      final updated = List.of(state.profiles)..removeAt(0);
      final bool loadMore = updated.isEmpty;

      emit(
        state.copyWith(
          profiles: updated,
          cardOffset: Offset.zero,
          rotation: 0,
          swipeOpacity: 0,
          shouldLoadMore: loadMore,

          // 🔥 UNDO İÇİN KAYIT
          lastSwipedProfile: swipedProfile,
          lastSwipeWasRight: isLike,
        ),
      );
    } else {
      emit(
        state.copyWith(
          cardOffset: Offset.zero,
          rotation: 0,
          swipeOpacity: 0,
        ),
      );
    }
  });
}


  void undoSwipe(BuildContext ctx) {
    final last = state.lastSwipedProfile;
    if (last == null) return;

    final width = MediaQuery.of(ctx).size.width;
    
    emit(
      state.copyWith(
        profiles: [last, ...state.profiles],
        cardOffset: Offset(
          state.lastSwipeWasRight ? width * 1.2 : -width * 1.2,
          -200,
        ),
        rotation: state.lastSwipeWasRight ? rotationMax : -rotationMax,
        swipeOpacity: 1,
        lastSwipedProfile: null,
      ),
    );

    Future.delayed(const Duration(milliseconds: 16), () {
      emit(
        state.copyWith(cardOffset: Offset.zero, rotation: 0, swipeOpacity: 0),
      );
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

  void onPanEnd(DragEndDetails d, BuildContext ctx) {
    final velocity = d.velocity.pixelsPerSecond.dx;
    final width = MediaQuery.of(ctx).size.width;

    const minFlingVelocity = 700;

    if (velocity > minFlingVelocity || state.cardOffset.dx > swipeThreshold) {
      _swipeLogic(
        Offset(width * 2, state.cardOffset.dy),
        rotationMax,
        removeCard: true,
      );
      return;
    }

    if (velocity < -minFlingVelocity || state.cardOffset.dx < -swipeThreshold) {
      _swipeLogic(
        Offset(-width * 2, state.cardOffset.dy),
        -rotationMax,
        removeCard: true,
      );
      return;
    }

    _springBack();
  }

  void _springBack() {
    emit(state.copyWith(cardOffset: Offset.zero, rotation: 0, swipeOpacity: 0));
  }
}
