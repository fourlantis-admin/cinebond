import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// ─────────────────────────────────────────────
//  STATE
// ─────────────────────────────────────────────

enum SwipeDirection { none, left, right, up }

class SwipeState<T> {
  final List<T> items;
  final Offset cardOffset;
  final double rotation;
  final double swipeOpacity;
  final bool shouldLoadMore;
  final T? lastSwipedItem;
  final bool lastSwipeWasRight;
  final SwipeDirection activeDirection;
  final bool isAnimating;
  // Match effect — ileride servis entegrasyonu için buraya bakılacak.
  final bool showMatchEffect;
  final T? matchedItem;

  const SwipeState({
    required this.items,
    this.cardOffset = Offset.zero,
    this.rotation = 0,
    this.swipeOpacity = 0,
    this.shouldLoadMore = false,
    this.lastSwipedItem,
    this.lastSwipeWasRight = true,
    this.activeDirection = SwipeDirection.none,
    this.isAnimating = false,
    this.showMatchEffect = false,
    this.matchedItem,
  });

  SwipeState<T> copyWith({
    List<T>? items,
    Offset? cardOffset,
    double? rotation,
    double? swipeOpacity,
    bool? shouldLoadMore,
    T? lastSwipedItem,
    bool? lastSwipeWasRight,
    SwipeDirection? activeDirection,
    bool? isAnimating,
    bool? showMatchEffect,
    T? matchedItem,
  }) {
    return SwipeState<T>(
      items: items ?? this.items,
      cardOffset: cardOffset ?? this.cardOffset,
      rotation: rotation ?? this.rotation,
      swipeOpacity: swipeOpacity ?? this.swipeOpacity,
      shouldLoadMore: shouldLoadMore ?? this.shouldLoadMore,
      lastSwipedItem: lastSwipedItem ?? this.lastSwipedItem,
      lastSwipeWasRight: lastSwipeWasRight ?? this.lastSwipeWasRight,
      activeDirection: activeDirection ?? this.activeDirection,
      isAnimating: isAnimating ?? this.isAnimating,
      showMatchEffect: showMatchEffect ?? this.showMatchEffect,
      matchedItem: matchedItem ?? this.matchedItem,
    );
  }
}

// ─────────────────────────────────────────────
//  CUBIT
// ─────────────────────────────────────────────

class SwipeCubit<T> extends Cubit<SwipeState<T>> {
  SwipeCubit({required List<T> items}) : super(SwipeState<T>(items: items));

  final double swipeThreshold = 100;
  final double rotationMax = pi / 12;

  // ── Public API ──────────────────────────────

  void swipeRight() => _swipeLogic(
        const Offset(2200, -350),
        rotationMax,
        SwipeDirection.right,
        // Butona basıldığında kart önce hafifçe sağa çekilir (wind-up).
        animate: true,
      );

  void swipeLeft() => _swipeLogic(
        const Offset(-2200, -350),
        -rotationMax,
        SwipeDirection.left,
        animate: true,
      );

  void swipeSuperLike() => _swipeLogic(
        const Offset(0, -2000),
        0,
        SwipeDirection.up,
        animate: true,
      );

  void addItems(List<T> newItems) {
    emit(state.copyWith(
      items: [...state.items, ...newItems],
      shouldLoadMore: false,
    ));
  }

  /// Match effect'i kapat — UI'dan çağrılır.
  void dismissMatchEffect() {
    emit(state.copyWith(showMatchEffect: false));
  }

  void undoSwipe(BuildContext ctx) {
    final last = state.lastSwipedItem;
    if (last == null || state.isAnimating) return;

    final width = MediaQuery.of(ctx).size.width;
    final wasRight = state.lastSwipeWasRight;

    emit(state.copyWith(
      items: [last, ...state.items],
      cardOffset: Offset(wasRight ? width * 1.5 : -width * 1.5, -200),
      rotation: wasRight ? rotationMax : -rotationMax,
      swipeOpacity: 1,
      lastSwipedItem: null,
      isAnimating: true,
    ));

    Future.delayed(const Duration(milliseconds: 50), () {
      emit(state.copyWith(
        cardOffset: Offset.zero,
        rotation: 0,
        swipeOpacity: 0,
        activeDirection: SwipeDirection.none,
        isAnimating: false,
      ));
    });
  }

  void onPanUpdate(DragUpdateDetails d, BuildContext ctx) {
    if (state.isAnimating) return;
    final newOffset = state.cardOffset + d.delta;
    final screenW = MediaQuery.of(ctx).size.width;

    final dragRatio = newOffset.dx / screenW;
    final rotation =
        (rotationMax * dragRatio).clamp(-rotationMax, rotationMax);
    final opacity =
        (newOffset.dx.abs() / (swipeThreshold * 2)).clamp(0.0, 1.0);

    SwipeDirection dir = SwipeDirection.none;
    if (newOffset.dx > 30) dir = SwipeDirection.right;
    if (newOffset.dx < -30) dir = SwipeDirection.left;
    if (newOffset.dy < -60 && newOffset.dx.abs() < 60) {
      dir = SwipeDirection.up;
    }

    emit(state.copyWith(
      cardOffset: newOffset,
      rotation: rotation,
      swipeOpacity: opacity,
      activeDirection: dir,
    ));
  }

  void onPanEnd(DragEndDetails d, BuildContext ctx) {
    if (state.isAnimating) return;
    final velocity = d.velocity.pixelsPerSecond;
    final screenW = MediaQuery.of(ctx).size.width;
    const minFling = 700.0;

    if (velocity.dy < -minFling && state.cardOffset.dx.abs() < 80) {
      swipeSuperLike();
      return;
    }
    if (velocity.dx > minFling || state.cardOffset.dx > swipeThreshold) {
      _swipeLogic(
        Offset(screenW * 2, state.cardOffset.dy),
        rotationMax,
        SwipeDirection.right,
      );
      return;
    }
    if (velocity.dx < -minFling || state.cardOffset.dx < -swipeThreshold) {
      _swipeLogic(
        Offset(-screenW * 2, state.cardOffset.dy),
        -rotationMax,
        SwipeDirection.left,
      );
      return;
    }

    _springBack();
  }

  // ── Private ─────────────────────────────────

  void _swipeLogic(
    Offset target,
    double rotation,
    SwipeDirection dir, {
    bool animate = false,
  }) {
    if (state.isAnimating || state.items.isEmpty) return;

    final isLike = dir == SwipeDirection.right;

    // Butona basılınca wind-up: kart önce biraz zıt yönde hareket eder,
    // kullanıcıya swipe başladığını hissettiren mikro animasyon.
    if (animate) {
      // Faz 1 — wind-up: kart zıt yönde gerilir, kullanıcı hareketi fark eder.
      final windUp = Offset(
        dir == SwipeDirection.left
            ? 38
            : dir == SwipeDirection.right
                ? -38
                : 0,
        dir == SwipeDirection.up ? 24 : 0,
      );

      emit(state.copyWith(
        cardOffset: windUp,
        activeDirection: dir,
        isAnimating: true,
      ));

      // Faz 2 — fırlatma: wind-up bittikten sonra kart ekrandan çıkar.
      Future.delayed(const Duration(milliseconds: 180), () {
        if (isClosed) return;
        emit(state.copyWith(
          cardOffset: target,
          rotation: rotation,
          swipeOpacity: 1,
          activeDirection: dir,
          isAnimating: true,
        ));
        _completeSwipe(isLike, dir);
      });
    } else {
      emit(state.copyWith(
        cardOffset: target,
        rotation: rotation,
        swipeOpacity: 1,
        activeDirection: dir,
        isAnimating: true,
      ));
      _completeSwipe(isLike, dir);
    }
  }

  void _completeSwipe(bool isLike, SwipeDirection dir) {
    Future.delayed(const Duration(milliseconds: 520), () {
      if (isClosed || state.items.isEmpty) return;

      final swiped = state.items.first;
      final updated = List<T>.from(state.items)..removeAt(0);

      // ── Match kontrolü ──────────────────────
      // Şu an her like'ta match tetikleniyor (mock).
      // İleride bu satırı servis çağrısıyla değiştir:
      // final isMatch = await MatchService.checkMatch(swiped);
      final isMatch = isLike;

      emit(state.copyWith(
        items: updated,
        cardOffset: Offset.zero,
        rotation: 0,
        swipeOpacity: 0,
        shouldLoadMore: updated.isEmpty,
        lastSwipedItem: swiped,
        lastSwipeWasRight: isLike,
        activeDirection: SwipeDirection.none,
        isAnimating: false,
        showMatchEffect: isMatch,
        matchedItem: isMatch ? swiped : null,
      ));
    });
  }

  void _springBack() {
    emit(state.copyWith(
      cardOffset: Offset.zero,
      rotation: 0,
      swipeOpacity: 0,
      activeDirection: SwipeDirection.none,
    ));
  }
}