import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:onlytag2/pages/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            cursorColor: const Color(0xffff9900)
        ),
        home: SplashScreen.navigate(name: 'lib/assets/splash/Splash.flr', next: (context) => Home(), until: () => Future.delayed(Duration(seconds: 3)),startAnimation: 'Intro', loopAnimation: 'Intro',)
    );
  }
}

