import 'package:cinebond/components/profile/gender_selector.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/components/textfield/custom_textfield.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectProfilePhotoView extends StatelessWidget {
  const SelectProfilePhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileCubit, CreateProfileState>(
      builder: (context, state) {
        final cubit = context.read<CreateProfileCubit>();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ================= AVATAR =================
              Center(
                child: GestureDetector(
                  onTap: cubit.pickProfilePhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B5CFF), Color(0xFF5F7CFF)],
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: state.profilePhoto != null
                              ? FileImage(state.profilePhoto!)
                              : null,
                          child: state.profilePhoto == null
                              ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.white70,
                                )
                              : null,
                        ),
                      ),
                
                      // ✏️ / 📷 BADGE
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white,size: 30),
                      ),
                    ],
                  ),
                ),
              ),

              VerticalSpacing(20),

              Text(
                state.profilePhoto == null
                    ? "Profil fotoğrafı ekle"
                    : "Eklendi",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              VerticalSpacing(8),

              Text(
                state.profilePhoto == null
                    ? "Profilini tamamlamak için net bir fotoğraf seç"
                    : "",

                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}
