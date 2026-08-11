import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/Screens/splash/splash_screen.dart';



void main() {
  runApp(const CookmateApp());
}

class CookmateApp extends StatelessWidget {
  const CookmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COOKmate',

      initialRoute: '/splash',

      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
        ),

        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('COOKmate Home'),
      ),
    );
  }
}