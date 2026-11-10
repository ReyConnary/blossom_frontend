import 'package:blossom_app/pages/login_page.dart';
import 'package:blossom_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // required before any async work pre-runApp

  // // TEMPORARY — clears stale session data, remove after running once
  // await (await SharedPreferences.getInstance()).clear();
  runApp(const BlossomApp());
}

class BlossomApp extends StatelessWidget {
  const BlossomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blossom School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      home: FutureBuilder<bool>(
  future: AuthService.tryAutoLogin(),
  builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return snapshot.data == true ? const HomePage() : const LoginPage();
  },
),
    );
  }
}
