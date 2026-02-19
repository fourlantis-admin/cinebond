import 'package:cinebond/controller/movie/favorites_cubit.dart';
import 'package:cinebond/splash_view.dart';
import 'package:cinebond/view/create-profile/create_profile_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cinebond/controller/form/form_cubit.dart';
import 'package:cinebond/controller/theme/theme_cubit.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/utils/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr'), Locale('en')],
      fallbackLocale: Locale('tr'),
      startLocale: Locale('tr'),
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => LoadingCubit()),
          BlocProvider(create: (_) => FormValidationCubit()),
          //BlocProvider<FavoritesCubit>(create: (_) => FavoritesCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (_, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "cinebond",
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,

          // 🌍 easy_localization entegrasyonu
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          home: SplashView(title: ""),
        );
      },
    );
  }
}
