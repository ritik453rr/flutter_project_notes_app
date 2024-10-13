import 'package:flutter/material.dart';
import 'package:notes_app/view_model/notes_view_model.dart';
import 'package:notes_app/view_model/weather_view_model.dart';
import 'package:notes_app/views/splash_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherViewModel(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
