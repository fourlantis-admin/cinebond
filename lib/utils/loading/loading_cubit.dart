import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingState {
  final bool isLoading;

  const LoadingState({required this.isLoading});
}

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(const LoadingState(isLoading: false));

  void show() {
    if (!state.isLoading) {
      emit(const LoadingState(isLoading: true));
    }
  }

  void hide() {
    if (state.isLoading) {
      emit(const LoadingState(isLoading: false));
    }
  }
}
