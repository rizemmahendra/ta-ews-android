import 'package:flutter/material.dart';
import 'package:ta_ews_application/app.dart';
import 'package:ta_ews_application/core.dart';
import 'package:ta_ews_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Constant.orange),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Constant.orange,
          )),
      home: const App(),
    );
  }
}
