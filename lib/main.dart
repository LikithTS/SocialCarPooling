import 'package:common/utils/storageutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialcarpooling/util/dimens.dart';
import 'package:socialcarpooling/utils/Localization.dart';
import 'package:socialcarpooling/view/splash/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initConfiguration();
    return ScreenUtilInit(
      designSize: Size(screenWidth, screenHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en'),
          localizationsDelegates: const [DemoLocalizationsDelegate()],
          supportedLocales: const [Locale('en', '')],
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: child,
        );
      },
      child: const SplashScreenPage(),
    );
  }

  void initConfiguration() {
    PreferencesUtil.getInstance();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.blue));
  }
}
