import 'package:cinebond/components/swipe/tinder_environment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SwipeState<T> {
  final List<T> items;
  final Offset cardOffset;
  final double rotation;
  final double swipeOpacity;
  final bool shouldLoadMore;

  final T? lastSwipedItem;
  final bool lastSwipeWasRight;

  SwipeState({
    required this.items,
    this.cardOffset = Offset.zero,
    this.rotation = 0,
    this.swipeOpacity = 0,
    this.shouldLoadMore = false,
    this.lastSwipedItem,
    this.lastSwipeWasRight = true,
  });

  SwipeState<T> copyWith({
    List<T>? items,
    Offset? cardOffset,
    double? rotation,
    double? swipeOpacity,
    bool? shouldLoadMore,
    T? lastSwipedItem,
    bool? lastSwipeWasRight,
  }) {
    return SwipeState<T>(
      items: items ?? this.items,
      cardOffset: cardOffset ?? this.cardOffset,
      rotation: rotation ?? this.rotation,
      swipeOpacity: swipeOpacity ?? this.swipeOpacity,
      shouldLoadMore: shouldLoadMore ?? this.shouldLoadMore,
      lastSwipedItem: lastSwipedItem ?? this.lastSwipedItem,
      lastSwipeWasRight: lastSwipeWasRight ?? this.lastSwipeWasRight,
    );
  }
}



class SwipeCubit<T> extends Cubit<SwipeState<T>> {
  SwipeCubit({required List<T> items})
      : super(SwipeState<T>(items: items));

  final double swipeThreshold = 100;
  final double rotationMax = pi / 10;

  void swipeRight() =>
      _swipeLogic(const Offset(2000, -450), rotationMax);

  void swipeLeft() =>
      _swipeLogic(const Offset(-2000, -450), -rotationMax);

  void addItems(List<T> newItems) {
    emit(state.copyWith(
      items: [...state.items, ...newItems],
      shouldLoadMore: false,
    ));
  }

  void _swipeLogic(Offset target, double rotation) {
    final isLike = rotation > 0;

    emit(state.copyWith(
      cardOffset: target,
      rotation: rotation,
      swipeOpacity: 1,
    ));

    Future.delayed(const Duration(milliseconds: 450), () {
      if (state.items.isEmpty) return;

      final swiped = state.items.first;
      final updated = List<T>.from(state.items)..removeAt(0);

      emit(state.copyWith(
        items: updated,
        cardOffset: Offset.zero,
        rotation: 0,
        swipeOpacity: 0,
        shouldLoadMore: updated.isEmpty,
        lastSwipedItem: swiped,
        lastSwipeWasRight: isLike,
      ));
    });
  }

  void undoSwipe(BuildContext ctx) {
    final last = state.lastSwipedItem;
    if (last == null) return;

    final width = MediaQuery.of(ctx).size.width;

    emit(state.copyWith(
      items: [last, ...state.items],
      cardOffset: Offset(
        state.lastSwipeWasRight ? width * 1.2 : -width * 1.2,
        -200,
      ),
      rotation: state.lastSwipeWasRight ? rotationMax : -rotationMax,
      swipeOpacity: 1,
      lastSwipedItem: null,
    ));

    Future.delayed(const Duration(milliseconds: 16), () {
      emit(state.copyWith(
        cardOffset: Offset.zero,
        rotation: 0,
        swipeOpacity: 0,
      ));
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
      );
      return;
    }

    if (velocity < -minFlingVelocity || state.cardOffset.dx < -swipeThreshold) {
      _swipeLogic(
        Offset(-width * 2, state.cardOffset.dy),
        -rotationMax,
      );
      return;
    }

    _springBack();
  }

  void _springBack() {
    emit(state.copyWith(cardOffset: Offset.zero, rotation: 0, swipeOpacity: 0));
  }
}


