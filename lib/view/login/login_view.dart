import 'package:cinebond/mixins/popup_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/buttons/secondary_button.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/components/textfield/custom_textfield.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/form/form_cubit.dart';
import 'package:cinebond/controller/login/login_cubit.dart';
import 'package:cinebond/controller/theme/theme_cubit.dart';
import 'package:cinebond/extensions/validators.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/repositories/google_repository.dart';
import 'package:cinebond/service/repositories/login/login_repository.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:cinebond/view/main/main_menu_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ViewStateMixin, PopupMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@override
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(LoginRepository(), GoogleAuthService()),
      ),
      BlocProvider<FormValidationCubit>(
        create: (_) => FormValidationCubit(),
      ),
    ],
    child: Builder( 
      builder: (context) {
        return MultiBlocListener(
          listeners: [
            
            BlocListener<LoginCubit, LoginState>(
              listenWhen: (prev, curr) =>
                  prev.isLoading != curr.isLoading,
              listener: (context, state) {
                if (state.isLoading) {
                  context.read<LoadingCubit>().show();
                } else {
                  context.read<LoadingCubit>().hide();
                }
              },
            ),

            BlocListener<LoginCubit, LoginState>(
              listenWhen: (prev, curr) =>
                  prev.success != curr.success && curr.success,
              listener: (context, state) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => MainMenuView()),
                  (_) => false,
                );
              },
            ),

            BlocListener<LoginCubit, LoginState>(
              listenWhen: (prev, curr) =>
                  prev.errorResp != curr.errorResp &&
                  curr.errorResp != null,
              listener: (context, state) {
                showGenericPopup(
                  title: state.errorResp!.error ?? "Error",
                  message: state.errorResp!.error_description ?? "",
                  primaryButtonText: "Tamam",
                  onPrimaryButtonPressed: (_) {
                    context.read<LoginCubit>().clearError();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
          child: HomeBaseView(
            isAppbarActive: false,
            isLoadingActive: true,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
                child: Column(
                  children: [
                    Flexible(flex: 4, child: _buildLogo()),
                    Flexible(flex: 4, child: _buildForm(context)),
                    VerticalSpacing(30),
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
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalSpacing(24),
              _buildEmailField(context),
              VerticalSpacing(34),
              _buildPasswordField(context),
              Spacer(),
              _buildLoginButton(context),
              VerticalSpacing(20),
              _buildSocialMediaButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitClicked(BuildContext context) {
    final req = LoginReq(
      username: "kubilay.kitapcioglu@cinebond.com",
      password: "123456",
    );
    try {
      context.read<LoginCubit>().authenticate(req, context);
    } catch (e) {
      print(e);
    }
  }

  void onThemeClicked(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(ImagesIcons.LOGO_W_TEXT, width: 330, height: 330),
    );
  }

  Widget _facebookButton(BuildContext context) {
    return SecondaryButton(
      btnWidth: 160,
      title: " ile Giriş Yap",
      trailingImagePath: ImagesIcons.FACEBOOK_LOGO,
      onClickBtnFunc: () {
        context.read<LoginCubit>().loginWithGoogle();
      },
    );
  }

  Widget _googleButton(BuildContext context) {
    return SecondaryButton(
      btnWidth: 160,

      title: " ile Giriş Yap",
      trailingImagePath: ImagesIcons.GOOGLE_LOGO,
      onClickBtnFunc: () {
        context.read<LoginCubit>().loginWithGoogle();
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return PrimaryButton(
      title: "submit".tr(),
      onClickBtnFunc: () {
        _formKey.currentState!.validate();
        final form = context.read<FormValidationCubit>();
        if (form.isValid()) {
          print("validated");
          onSubmitClicked(context);
        }
      },
      btnHeight: 50,
      btnWidth: 230,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      labelText: "password".tr(),
      inputType: TextInputType.visiblePassword,
      textController: passwordController,
      validator: (value) {
        final error = value?.isEmptyFields();
        context.read<FormValidationCubit>().setFieldError("password", error);
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
        final error = value?.isEmptyFields();
        context.read<FormValidationCubit>().setFieldError("email", error);
        return error;
      },
    );
  }

  Widget _buildSocialMediaButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [_googleButton(context), _facebookButton(context)],
    );
  }
}
