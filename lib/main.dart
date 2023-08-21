import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:buyer/features/Home/presentation/state_management/offer_image_url_provider.dart';
import 'package:buyer/features/Home/presentation/state_management/user_data_provider.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/features/splash/splash_screen.dart';
import 'package:buyer/utilities/color_theme.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //will check for website then future will uncomment this
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //for changeing local language
          create: (_) => LocalProvider(),
        ),
        ChangeNotifierProvider(
            //for Theme
            create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
            //Image for Displaying Offer in home screen
            create: (_) => OfferImageUrlProvider()),
        ChangeNotifierProvider(create: (ctx) => UserDataProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, provider, child) {
        return Consumer<LocalProvider>(
            builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoute.onGenerateRoute,
            initialRoute: "/",
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('kn'), // kannada
            ],
            title: 'Flutter Demo',
            themeMode: provider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: SplashScreen(),
          );
        });
      }),
    );
  }
}
