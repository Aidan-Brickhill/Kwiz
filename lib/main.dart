import 'dart:ffi';
import 'package:kwiz/pages/home.dart';
import 'package:kwiz/pages/create_quiz.dart';
import 'package:kwiz/pages/viewquizzes/viewquizzes.dart';
import 'package:kwiz/quiz_screen.dart';
import 'package:kwiz/start_quiz.dart';
import 'package:kwiz/view_categories.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwiz/Models/Questions.dart';
import 'package:kwiz/Models/Quizzes.dart';
import 'package:kwiz/firebase_options.dart';
import 'package:kwiz/services/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Color.fromARGB(255, 49, 49, 49),
      primarySwatch: MaterialColor(
        0xFF24A45A, // This is your custom color in RGB(36,164,90) format
        <int, Color>{
          50: Color(0xFFF2F9F4),
          100: Color(0xFFD6EFE4),
          200: Color(0xFFADD8C6),
          300: Color(0xFF84C0A8),
          400: Color(0xFF5AAE8D),
          500: Color(
              0xFF24A45A), // This is your custom color in RGB(36,164,90) format
          600: Color(0xFF209A54),
          700: Color(0xFF1C8F4D),
          800: Color(0xFF188445),
          900: Color(0xFF117534),
        },
      ),
      accentColor:
          Color.fromARGB(255, 67, 162, 89), // Set the accent color to purple
    ),
    home: AddQuiz(),
  ));
}
