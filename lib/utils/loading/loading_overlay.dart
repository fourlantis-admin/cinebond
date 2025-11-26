import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'loading_cubit.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        if (!state.isLoading) {
          return SizedBox.shrink();
        }

        return Container(
          color: Colors.black.withOpacity(0.4),
          alignment: Alignment.center,
          child: Lottie.asset(
            ImagesIcons.LOADING_ANIMATION,
            width: 200,
            height: 200,
            repeat: true,
          ),
        );
      },
    );
  }
}
