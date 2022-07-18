import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gerador_senha/main_context.dart';
import 'package:gerador_senha/page/home_page.dart';
import 'package:localization/localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainContext _mainContext = MainContext();

  @override
  void initState() {
    super.initState();
     _mainContext.brightnessNotifier.value = WidgetsBinding.instance.window.platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _mainContext.brightnessNotifier,
      builder: (context, snapshot, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'title'.i18n(),
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: snapshot,
            cardTheme: const CardTheme(elevation: 10),
            toggleableActiveColor: Colors.deepPurpleAccent,
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale("pt", "BR"),
            Locale("en", "US")
          ],
          localeResolutionCallback: (locale, supportedLocale){            
            if(supportedLocale.contains(locale)){
              return locale;
            }    
            return const Locale("en", "US");
          },
          home: HomePage(_mainContext),
        );
      }
    );
  }
}
