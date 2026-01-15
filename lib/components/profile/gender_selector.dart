import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';

import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onSelect,
  });

  final String? selectedGender;
  final ValueChanged<String> onSelect;

  static const List<String> genders = ["Kadın", "Erkek", "Diğer"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: genders.map((g) {
          final active = selectedGender == g;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(g),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: active
                      ? const LinearGradient(
                          colors: [
                            AppColor.MAIN_PURPLE,
                            AppColor.MAIN_BLUE,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: active ? null : Colors.white.withOpacity(0.08),
                  border: Border.all(
                    color: active
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.15),
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color:
                                AppColor.MAIN_PURPLE.withOpacity(0.45),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: AnimatedScale(
                  scale: active ? 1.05 : 1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _genderIcon(g, active),
                      const SizedBox(height: 6),
                      Text(
                        g,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              active ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _genderIcon(String gender, bool active) {
    IconData icon;
    switch (gender) {
      case "Kadın":
        icon = Icons.female;
        break;
      case "Erkek":
        icon = Icons.male;
        break;
      default:
        icon = Icons.transgender;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
