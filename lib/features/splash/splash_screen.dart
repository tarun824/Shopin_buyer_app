import 'package:buyer/features/category/presentation/pages/state_management/category_provider.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/color_theme.dart';
import 'package:buyer/utilities/theme_mode_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any necessary initialization code or delayed actions here
    // For example, you can load data or perform other tasks
    // You can use Future.delayed() for a simple delay
    // or use a Future for more complex operations

// will check for tryLogin
    // Navigate to the next screen after the splash screen
    Future.delayed(const Duration(seconds: 2), () async {
      final forTheme = Provider.of<ThemeProvider>(context, listen: false);
      final _userId = await TryAutoLogin().tryAutoLogin();

      final themeMode =
          await ThemeModeService().themeModeServiceTryToGetThemeMode();
      if (themeMode != null) {
        forTheme.setThemeModeFromRemote(themeMode);
        await ThemeModeService().themeModeServiceWrite(themeMode);
      }

      if (_userId == null) {
        Navigator.pushReplacementNamed(
          context,
          "/introductionScreen",
        );
      } else {
        Navigator.pushReplacementNamed(context, "/mainPageNavigator",
            arguments: _userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 223,
            child: ClipOval(
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 68.0),
            child: Text(
              'Shop in',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
