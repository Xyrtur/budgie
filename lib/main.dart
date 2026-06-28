import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const BudgieApp());
}

class BudgieApp extends StatelessWidget {
  const BudgieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'GB'),
        ],
        title: "Budgie",
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          fontFamily: 'Raleway',
        ),
        home: RepositoryProvider(create: (context) => BudgieDatabase(), child: const LandingPageView()),
      ),
    );
  }
}
