import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/profile/step_header.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:cinebond/service/movie/movie_repository.dart';
import 'package:cinebond/view/create-profile/name_surname_view.dart';
import 'package:cinebond/view/create-profile/select_movie_view.dart';
import 'package:cinebond/view/create-profile/select_profile_photo_view.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CreateProfileView extends StatelessWidget{
  CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateProfileCubit(movieRepo: MovieRepository(context: context)),
      child: HomeBaseView(
        body: BlocBuilder<CreateProfileCubit, CreateProfileState>(
          builder: (context, state) {
            final cubit = context.read<CreateProfileCubit>();
            return Column(
              children: [
                StepHeader(step: state.step),
                Expanded(
                  child: IndexedStack(
                    index: state.step,
                    children: [
                      NameSurnameView(), // Step 0
                      SelectMovieView(), // Step 1 (Favorite movies)
                      SelectProfilePhotoView(),        // Step 2 (Photo)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: PrimaryButton(
                    title: state.step == 2 ? "Tamamla" : "Devam Et",
                    onClickBtnFunc: () =>  state.isValid
                        ? cubit.nextStep(context)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
