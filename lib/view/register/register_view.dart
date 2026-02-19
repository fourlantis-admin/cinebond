import 'package:cinebond/controller/register/register_cubit.dart';
import 'package:cinebond/mixins/popup_mixin.dart';
import 'package:cinebond/models/register/communication_permissions_req.dart';
import 'package:cinebond/models/register/register_req.dart';
import 'package:cinebond/utils/mask/phone_input_formatter.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/create-profile/create_profile_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/components/textfield/custom_textfield.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/form/form_cubit.dart';
import 'package:cinebond/controller/theme/theme_cubit.dart';
import 'package:cinebond/extensions/validators.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/service/repositories/google_repository.dart';
import 'package:cinebond/service/repositories/user/user_repository.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:cinebond/view/main/main_menu_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with ViewStateMixin, PopupMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(
          create: (_) => RegisterCubit(
            UserRepository(),
            GoogleAuthService(),
            StoreManager(),
          ),
        ),
        BlocProvider<RegisterValidationCubit>(
          create: (_) => RegisterValidationCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<RegisterCubit, RegisterState>(
                listenWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                listener: (context, state) {
                  if (state.isLoading) {
                    context.read<LoadingCubit>().show();
                  } else {
                    context.read<LoadingCubit>().hide();
                  }
                },
              ),

              BlocListener<RegisterCubit, RegisterState>(
                listenWhen: (prev, curr) =>
                    prev.success != curr.success && curr.success,
                listener: (context, state) {
                  showGenericPopup(
                    title: "Başarılı",
                    message: "Kayıt oldun!",
                    primaryButtonText: "Devam Et",
                    onPrimaryButtonPressed: (_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => CreateProfileView()),
                        (_) => false,
                      );
                    },
                  );
                },
              ),

              BlocListener<RegisterCubit, RegisterState>(
                listenWhen: (prev, curr) =>
                    prev.errorResp != curr.errorResp && curr.errorResp != null,
                listener: (context, state) {
                  showGenericPopup(
                    title: state.errorResp!.error ?? "Error",
                    message: state.errorResp!.error_description ?? "",
                    primaryButtonText: "Tamam",
                    onPrimaryButtonPressed: (_) {
                      context.read<RegisterCubit>().clearError();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
            child: HomeBaseView(
              isAppbarActive: true,
              isLoadingActive: true,
              appBar: buildAppbarWithBackButton(
                isBackButtonActive: true,
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: _buildLogo(),
                      ),
                      VerticalSpacing(5),
                      Expanded(child: _buildForm(context)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    double spacing = 13;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                _buildEmailField(context),
                VerticalSpacing(spacing),
                _buildPhoneField(context),
                VerticalSpacing(spacing),
                _buildPasswordField(context),
                Spacer(),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitClicked(BuildContext context) {
    final req = RegisterReq(
      firstName: "kubitest",
      lastName: "kitaptest",
      email: emailController.text, //"kubitest@gmail.com",
      GDPRPermission: true,
      communicationPermissions: CommunicationPermissionsReq(
        email: true,
        phone: true,
        sms: true,
      ),
      phone: phoneController.text.cleanPhoneNumberMask(), //"05445287770",
      password: passwordController.text, //"123456",
    );
    try {
      context.read<RegisterCubit>().register(req, context);
    } catch (e) {
      print(e);
    }
  }

  void onThemeClicked(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(left: 2.0, right: 2, top: 5),
      child: Container(
        padding: const EdgeInsets.all(4), // gradient border kalınlığı
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.MAIN_PURPLE, AppColor.MAIN_BLUE],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(ImagesIcons.MCLOVIN_IMAGE, fit: BoxFit.fill),
              Container(color: Colors.black.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return PrimaryButton(
      title: "Kayıt Ol",
      onClickBtnFunc: () {
        _formKey.currentState!.validate();
        final form = context.read<RegisterValidationCubit>();
        if (form.isValid()) {
          print("validated");
          onSubmitClicked(context);
        }
      },
      btnHeight: 55,
      btnWidth: 270,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      labelText: "password".tr(),
      inputType: TextInputType.visiblePassword,
      textController: passwordController,
      validator: (value) {
        final error = value?.isEmptyFields();
        print(error);

        context.read<RegisterValidationCubit>().setFieldError(
          "password",
          error,
        );
        return error;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return CustomTextField(
      labelText: "Telefon",
      inputType: TextInputType.phone,
      textController: phoneController,
      inputFormatters: [PhoneNumberFormatter()],
      validator: (value) {
        final error = value?.isEmptyFields();
        print(error);

        context.read<RegisterValidationCubit>().setFieldError("phone", error);
        return error;
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      labelText: "email".tr(),
      inputType: TextInputType.emailAddress,
      textController: emailController,
      validator: (value) {
        final error = value?.isValidEmail();
        print(error);
        context.read<RegisterValidationCubit>().setFieldError("email", error);
        return error;
      },
    );
  }
}
