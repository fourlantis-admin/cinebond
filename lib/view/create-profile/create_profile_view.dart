import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/profile/step_header.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/create-profile/name_surname_view.dart';
import 'package:cinebond/view/create-profile/select_movie_view.dart';
import 'package:cinebond/view/create-profile/select_profile_photo_view.dart';
import 'package:cinebond/view/main/main_menu_view.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> with ViewStateMixin{
  late final CreateProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreateProfileCubit(
      movieRepo: MovieRepository(),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CreateProfileCubit, CreateProfileState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CreateProfileStatus.loading) {
            context.read<LoadingCubit>().show();
          }

          if (state.status == CreateProfileStatus.success) {
            context.read<LoadingCubit>().hide();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MainMenuView(),
              ),
            );
          }

          if (state.status == CreateProfileStatus.error) {
            context.read<LoadingCubit>().hide();

            print("HATA!");
          }
        },
        builder: (context, state) {
          return HomeBaseView(
            appBar: buildAppbarWithOnlyBackButton(onBackButtonPressed: () {
              Navigator.of(context).pop();
            },),
            body: Column(
              children: [
                StepHeader(step: state.step),
                Expanded(
                  child: IndexedStack(
                    index: state.step,
                    children: const [
                      NameSurnameView(),
                      SelectMovieView(),
                      SelectProfilePhotoView(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: PrimaryButton(
                    title:
                        state.step == 2 ? "Tamamla" : "Devam Et",
                    onClickBtnFunc: state.isValid
                        ? () => context
                            .read<CreateProfileCubit>()
                            .nextStep()
                        : null,
                  ),
                ),
               VerticalSpacing(65)
              ],
            ),
          );
        },
      ),
    );
  }
}
