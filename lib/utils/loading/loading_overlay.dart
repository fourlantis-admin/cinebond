import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'loading_cubit.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        if (!state.isLoading) return const SizedBox.shrink();

        return Positioned.fill( 
          bottom: 40,
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(  
              child: _buildAnimation(),
            ),
          ),
        );
      },
    );
  }
  Widget? _buildAnimation() {
   return Lottie.asset(
            ImagesIcons.LOADING_ANIMATION,
            width: 150,
            height: 150,
            repeat: true,
          );
  }

}

  
  
