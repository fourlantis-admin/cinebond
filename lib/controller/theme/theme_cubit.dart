import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    emit(ThemeState(themeMode: isDark ? ThemeMode.light : ThemeMode.dark));
  }

  void setTheme(ThemeMode mode) {
    emit(ThemeState(themeMode: mode));
  }
}
