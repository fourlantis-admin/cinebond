import 'package:cinebond/components/profile/gender_selector.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/components/textfield/custom_textfield.dart';
import 'package:cinebond/controller/create-profile/create_profile.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameSurnameView extends StatefulWidget {
  const NameSurnameView({super.key});

  @override
  State<NameSurnameView> createState() => _NameSurnameViewState();
}

class _NameSurnameViewState extends State<NameSurnameView> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreateProfileCubit>();

    nameController.addListener(() {
      cubit.setName(nameController.text.trim());
    });

    surnameController.addListener(() {
      cubit.setSurname(surnameController.text.trim());
    });

    ageController.addListener(() {
  final value = int.tryParse(ageController.text);
  if (value != null) cubit.setAge(value);
});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileCubit, CreateProfileState>(
      builder: (context, state) {
        final cubit = context.read<CreateProfileCubit>();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                labelText: "Ad",
                textController: nameController,
              ),
              const VerticalSpacing(12),
              CustomTextField(
                labelText: "Soyad",
                textController: surnameController,
              ),
              const VerticalSpacing(12),
              CustomTextField(
                labelText: "Yaş",
                inputType: TextInputType.number,
                textController: ageController,
              ),
              const VerticalSpacing(20),

              GenderSelector(
                selectedGender: state.gender,
                onSelect: cubit.setGender,
              ),
            ],
          ),
        );
      },
    );
  }
}
