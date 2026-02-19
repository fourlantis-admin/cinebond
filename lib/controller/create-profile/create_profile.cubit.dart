import 'dart:io';

import 'package:cinebond/models/user/generic_by_id_req.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/service/repositories/user/user_repository.dart';
import 'package:cinebond/view/main/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/models/movie/movie_resp.dart';
import 'package:image_picker/image_picker.dart';

enum CreateProfileStatus { initial, loading, success, error }

class CreateProfileState {
  final CreateProfileStatus status;
  final String? errorMessage;
  final int step;

  // STEP 0
  final String name;
  final String surname;
  final int? age;
  final String? gender;

  // STEP 1 – MOVIES
  final List<MovieResp> movies;
  final List<MovieResp> filteredMovies;
  final List<MovieResp> selectedMovies;
  final bool isMoviesLoading;

  // STEP 2 – PHOTO
  final File? profilePhoto;

  final bool isValid;

  const CreateProfileState({
    this.status = CreateProfileStatus.initial,
    this.errorMessage,
    this.step = 0,
    this.name = '',
    this.surname = '',
    this.age,
    this.gender,

    this.movies = const [],
    this.filteredMovies = const [],
    this.selectedMovies = const [],
    this.isMoviesLoading = false,

    this.profilePhoto,

    this.isValid = true,
  });

  CreateProfileState copyWith({
    CreateProfileStatus? status,
    String? errorMessage,
    int? step,
    String? name,
    String? surname,
    int? age,
    String? gender,

    List<MovieResp>? movies,
    List<MovieResp>? filteredMovies,
    List<MovieResp>? selectedMovies,
    bool? isMoviesLoading,

    File? profilePhoto,

    bool? isValid,
  }) {
    return CreateProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      step: step ?? this.step,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      movies: movies ?? this.movies,
      filteredMovies: filteredMovies ?? this.filteredMovies,
      selectedMovies: selectedMovies ?? this.selectedMovies,
      isMoviesLoading: isMoviesLoading ?? this.isMoviesLoading,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isValid: isValid ?? this.isValid,
    );
  }
}

class CreateProfileCubit extends Cubit<CreateProfileState> {
  final MovieRepository movieRepo;
  final ImagePicker _picker = ImagePicker();
  final UserRepository userRepo = UserRepository();
  CreateProfileCubit({required this.movieRepo})
    : super(const CreateProfileState());

  // ---------- STEP 0 ----------
  void setName(String value) {
    emit(state.copyWith(name: value));
    _validate();
  }

  void setSurname(String value) {
    emit(state.copyWith(surname: value));
    _validate();
  }

  void setAge(int? value) {
    emit(state.copyWith(age: value));
    _validate();
  }

  void setGender(String value) {
    emit(state.copyWith(gender: value));
    _validate();
  }

  // ---------- STEP NAV ----------
  void nextStep() {
    if (state.step == 2) {
      _completeProfile();
      return;
    }
    if (!state.isValid) return;

    emit(state.copyWith(step: state.step + 1, isValid: true));
  }

  // ---------- STEP 1 – MOVIES ----------
  Future<void> fetchMovies(BuildContext context) async {
    emit(state.copyWith(isMoviesLoading: true));

    try {
      final movies = await movieRepo.getMovies(
        context,
        pageNumber: "1",
        filter: "",
      );

      emit(
        state.copyWith(
          movies: movies,
          filteredMovies: movies,
          isMoviesLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isMoviesLoading: false));
    }
  }

  Future<void> searchMovie(BuildContext context, String query) async {
    if (query.length < 2) {
      emit(state.copyWith(filteredMovies: state.movies));
      return;
    }

    emit(state.copyWith(isMoviesLoading: true));

    try {
      final results = await movieRepo.getMovies(context, filter: query);

      emit(state.copyWith(filteredMovies: results, isMoviesLoading: false));
    } catch (_) {
      emit(state.copyWith(isMoviesLoading: false));
    }
  }

  void toggleMovie(MovieResp movie) {
    final selected = List<MovieResp>.from(state.selectedMovies);

    if (selected.any((m) => m.id == movie.id)) {
      selected.removeWhere((m) => m.id == movie.id);
    } else {
      if (selected.length >= 10) return;
      selected.add(movie);
    }

    emit(state.copyWith(selectedMovies: selected));
    _validate();
  }

  // ---------- STEP 2 – PHOTO ----------
  Future<void> pickProfilePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final file = File(image.path);
    debugPrint("📸 picked image: ${file.path}");
    GenericByIdReq req = GenericByIdReq(id: file.path);
    try {
      final response = await userRepo.setProfilePicture(req);
      print(response);

    } catch (e) {
      emit(
        state.copyWith(
          status: CreateProfileStatus.error,
          errorMessage: "Profil fotoğraf",
        ),
      );
    }

    emit(state.copyWith(profilePhoto: file));
    _validate();
  }

  // ---------- VALIDATION ----------
  void _validate() {
    bool valid = false;

    switch (state.step) {
      case 0:
        valid =
            state.name.isNotEmpty &&
            state.surname.isNotEmpty &&
            state.age != null &&
            state.gender != null;
        break;

      case 1:
        valid = state.selectedMovies.length == 10;
        break;

      case 2:
        valid = state.profilePhoto != null;
        break;
    }

    emit(state.copyWith(isValid: valid));
  }

  Future<void> _completeProfile() async {
    emit(state.copyWith(status: CreateProfileStatus.loading));

    try {
      // burada userRepo save profile vs yap
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: CreateProfileStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateProfileStatus.error,
          errorMessage: "Profil oluşturulamadı",
        ),
      );
    }
  }
}
