import 'package:app_links/app_links.dart';
import 'package:fardinexpress/config/routes/route_generator.dart';
import 'package:fardinexpress/config/themes/light_theme.dart';
import 'package:fardinexpress/features/app/app_dependencies/app_dependencies.dart';
import 'package:fardinexpress/features/app/splash_screen/splash_page.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/login/bloc/login_bloc.dart';
import 'package:fardinexpress/features/auth/login/bloc/register_bloc.dart';
import 'package:fardinexpress/utils/bloc/toggle_btn/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'features/language/model/app_localization.dart';

// enum Env { Production, Developement }
// final Env env = Env.Production;
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  await GetStorage.init();
  final locale = GetStorage().read('locale') ?? "km";
  AppLocalization.changeLocale(locale);
  await dotenv.load(fileName: 'assets/.env');
  await AppDependencies.init();
  configLoading();
  runApp(const MyApp());
}

// void configLoading() {
//   EasyLoading.instance
//     ..loadingStyle = EasyLoadingStyle.light
//     ..indicatorType = EasyLoadingIndicatorType.circle
//     ..indicatorColor = Colors.green
//     ..userInteractions = false
//     ..dismissOnTap = false;
// }
void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.light
    // ..backgroundColor = Colors.white
    // ..indicatorColor = Colors.black
    ..textColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = false;
}

// String getServerEnvAssetPath(Env env) {
//   late final String path;
//   switch (env) {
//     case Env.Developement:
//       path = 'assets/dev.env';
//       break;
//     case Env.Production:
//       path = 'assets/.env';
//       break;
//   }
//   return path;
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) =>
                AuthenticationBloc()..add(AppLoaded()),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<RegisterBloc>(
            create: (BuildContext context) => RegisterBloc(),
          ),
          BlocProvider<ToggleBloc>(
            create: (BuildContext context) => ToggleBloc(),
          ),
        ],
        child: GetMaterialApp(
          title: 'Fardin Express',
          translations: AppLocalization(),
          locale: AppLocalization.locale,
          fallbackLocale: AppLocalization.fallbackLocale,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.generateRoute,
          theme: lightTheme,
          builder: EasyLoading.init(),
          home: SplashPage(),
        ));
  }
}
