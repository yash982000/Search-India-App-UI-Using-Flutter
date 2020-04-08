import 'package:flutter/material.dart' show BuildContext, Locale, MaterialApp, StatelessWidget, ThemeData, Widget, WidgetsFlutterBinding, runApp;
import 'package:search_india/main_page.dart' show MainPage;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalMaterialLocalizations, GlobalWidgetsLocalizations;
import 'package:easy_localization/easy_localization.dart' show EasyLocalization;

void main() async {
  var ensureInitialized = WidgetsFlutterBinding.ensureInitialized();
    runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [
        Locale('hi', 'IN'),
        Locale('en', 'IN'),
        Locale('bn', 'IN')
      ],
      path: 'resources/language_json',
    ));                                                  
  }


mixin MyApp implements StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasyLocalization.of(context).delegate,
          ],
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          initialRoute: '/',
          routes: {'/': (context) => MainPage()},
        );                                                 
        return materialApp;                               
  }
}
