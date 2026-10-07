import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final repository = BudgieDatabase();
  await repository.initializeSettings();

  runApp(BudgieApp(repository: repository));
}

class BudgieApp extends StatelessWidget {
  final BudgieDatabase repository;
  const BudgieApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'GB')],
        title: "Budgie",
        theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Raleway'),
        home: RepositoryProvider<BudgieDatabase>.value(
          value: repository,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NavbarCubit>(create: (context) => NavbarCubit(PageSelected.Overview)),
              BlocProvider<FABIconCubit>(create: (context) => FABIconCubit()),
              BlocProvider<SpendingGraphViewToggleCubit>(create: (context) => SpendingGraphViewToggleCubit()),
              BlocProvider<WarmModeToggleCubit>(create: (context) => WarmModeToggleCubit()),
              BlocProvider<TempTripRecordsCubit>(create: (context) => TempTripRecordsCubit()),
            ],

            child: const LandingPageView(),
          ),
        ),
      ),
    );
  }
}
