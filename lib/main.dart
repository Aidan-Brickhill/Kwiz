import 'dart:ffi';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String ReturnedID;
  DatabaseService service = DatabaseService();

  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //add quiz with list of questions
            TextButton(
              onPressed: () async {
                late List<Question> questions = [];
                Question q1 = Question(
                    QuestionNumber: 1,
                    QuestionText: 'Question 1',
                    QuestionAnswer: 'Question 1 Answer',
                    QuestionMark: 1);
                Question q2 = Question(
                    QuestionNumber: 2,
                    QuestionText: 'Question 2',
                    QuestionAnswer: 'Question 2 Answer',
                    QuestionMark: 1);
                Question q3 = Question(
                    QuestionNumber: 3,
                    QuestionText: 'Question 3',
                    QuestionAnswer: 'Question 3 Answer',
                    QuestionMark: 1);
                questions.add(q1);
                questions.add(q2);
                questions.add(q3);
                //needs quiz parameter
                Quiz quiz = Quiz(
                    QuizName: 'Quiz 1 Name',
                    QuizCategory: 'Cat 2',
                    QuizDescription: 'Quiz 1Description',
                    QuizMark: 3,
                    QuizDateCreated: 'QuizDateCreated',
                    QuizQuestions: questions,
                    QuizID: '');

                await service.addQuizWithQuestions(quiz);
              },
              child: Text('Add Quiz With List of Question'),
            ),
            //get Categories
            TextButton(
              onPressed: () async {
                List? Categories = await service.getCategories();
                print(Categories);
              },
              child: Text('Get Categories'),
            ),
            //get all quizzes
            TextButton(
              onPressed: () async {
                List<Quiz>? AllQuizzes = await service.getAllQuizzes();
                print(AllQuizzes!.length);
              },
              child: Text('Get All Quizzes'),
            ),
            //get quiz and question
            TextButton(
              onPressed: () async {
                Quiz? quiz = await service.getQuizAndQuestions(
                    QuizID: '9mUH393IQ9Bj5mgPsYKP');
                print(quiz!.QuizQuestions.elementAt(0).QuestionText);
                print(quiz!.QuizQuestions.elementAt(1).QuestionText);
                print(quiz!.QuizQuestions.elementAt(2).QuestionText);
              },
              child: Text('Get Quiz with Questions'),
            ),
            //get quiz based on cat
            TextButton(
              onPressed: () async {
                List<Quiz>? CategoryQuiz =
                    await service.getQuizByCategory(Category: 'Cat 2');
                print(CategoryQuiz!.length);
              },
              child: Text('Get Category based Quiz'),
            ),
            // const Text(
            //   'Luca and Christine and Aidan has pushed the button this many times, you should too (lol):',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     DatabaseService service = DatabaseService();
      //     service.addQuizCollection();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
