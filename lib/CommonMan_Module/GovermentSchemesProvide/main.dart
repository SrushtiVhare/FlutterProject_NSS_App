import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/AppLocalizations.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/LanguageProvider.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeListScreen.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeProvider.dart';
import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     if (kIsWeb) {
//       await Firebase.initializeApp(
//         options: const FirebaseOptions(
//           apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
//           appId: "1:994090021321:web:37937c4ad50ea891edf818",
//           messagingSenderId: "994090021321",
//           projectId: "project1-219ef",
//           authDomain: "project1-219ef.firebaseapp.com",
//           storageBucket: "project1-219ef.appspot.com",
//         ),
//       );
//     } else {
//       await Firebase.initializeApp(
//         options: const FirebaseOptions(
//           apiKey: "AIzaSyDkEGryfJouqLI3PYOI3PGEJtslJZ5kcNY",
//           appId: "1:994090021321:android:37937c4ad50ea891edf818",
//           messagingSenderId: "994090021321",
//           projectId: "project1-219ef",
//           storageBucket: "project1-219ef.appspot.com",
//         ),
//       );
//     }
//     print('Firebase initialized successfully');
//   } catch (e) {
//     print('Error initializing Firebase: $e');
//   }

//   runApp(const GovernmentScheme());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize(); // One line initialization
  runApp(const GovernmentScheme());
}

class GovernmentScheme extends StatelessWidget {
  const GovernmentScheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'NSS - Government Schemes',
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('mr', ''),
              Locale('hi', ''),
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF000080),
                primary: const Color(0xFF000080),
                secondary: const Color(0xFFF97316),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(elevation: 4, centerTitle: false),
            ),
            home: const SchemeListScreen(),
          );
        },
      ),
    );
  }
}
