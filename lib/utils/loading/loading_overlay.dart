import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'loading_cubit.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        if (!state.isLoading) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.45),
          child: Center(
            child: Lottie.asset(
              ImagesIcons.LOADING_ANIMATION,
              width: 150,
              height: 150,
              repeat: true,
            ),
          ),
        );
      },
    );
  }
}


  
  
