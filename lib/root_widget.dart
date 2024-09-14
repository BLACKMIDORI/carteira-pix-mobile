import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/views/home_page.dart';
import 'package:flutter/material.dart';

/// Root widget of the app
class MyApp extends StatelessWidget {
  /// Root Widget constructor
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carteira Pix',
      theme: BlackMidoriTheme.darkMode(),
      home: const HomePage(),
    );
  }
}
