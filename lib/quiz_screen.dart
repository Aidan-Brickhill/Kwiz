import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kwiz/hello.dart';
import 'package:kwiz/firebase_options.dart';
import 'package:kwiz/services/database.dart';

import 'Models/Quizzes.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  DatabaseService service = DatabaseService();
  late bool _isLoading;
  int quizLength = 0;
  Quiz? quiz;

  // Get the questions from firebase in thsi fucntion via a quiz class
  Future<void> loaddata() async {
    //once loading starts, _isloading is set to true
    setState(() {
      _isLoading = true;
    });
    //ID must be sent from previous page
    quiz = await service.getQuizAndQuestions(QuizID: 'TJvZqgQaVC9LkBqeVqlL');
    quizLength = quiz!.QuizQuestions.length;
    userAnswers = List.filled(quizLength, '');
    popList(quiz);
    //once loading finishies, _isloading is set to false
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    //call loaddata on init
    loaddata();
    //this after
    super.initState();
  }

  void popList(Quiz? q) {
    for (int i = 0; i < quizLength; i++) {
      questions.add(q!.QuizQuestions.elementAt(i).QuestionText);
      answers.add(q.QuizQuestions.elementAt(i).QuestionAnswer);
    }
  }

  List<String> questions = [];
  List<String> answers = [];
  List<String> userAnswers = [];

  // Controller for the answer input field
  TextEditingController answerController = TextEditingController();

  //user input answers
  //List<String> userAnswers = List.filled(3, ''); //make this dynamic!!!
  // Index of the current question
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    void updateText() {
      answerController.text = userAnswers[currentIndex];
    }

    //load before data comes then display ui after data is recieved with the isloading variable
    return Scaffold(
      //checks if loading
      appBar: _isLoading
          ? null
          //after data is loaded this displays
          : AppBar(
              title: Text(quiz!.QuizName),
            ),
      body: SafeArea(
        //checks if loading
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            //after data is loaded this displays
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Image.asset('assets/images/geo1.jpg'),
                    ),

                    // Display the question number and question text

                    Text(
                      'Question ${currentIndex + 1} of ${questions.length}', //
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      questions[currentIndex],
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 32.0),
                    // Input field for the answer

                    TextField(
                      controller: answerController,
                      decoration: InputDecoration(
                        hintText: 'Type your answer here',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 107, 106, 106)),
                      ),
                    ),

                    SizedBox(height: 32.0),
                    // Buttons for moving to the previous/next question
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentIndex > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentIndex--;
                                updateText();
                                //print(currentIndex);
                                //answerController.clear();
                              });
                            },
                            child: Text('Previous'),
                          ),
                        if (currentIndex < questions.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              userAnswers[currentIndex] =
                                  answerController.text.trim();
                              /////userAnswers.add(answerController.text.trim());
                              // print(userAnswers);
                              setState(() {
                                currentIndex++;
                                updateText();
                                //print(currentIndex);
                                //answerController.clear();
                              });
                            },
                            child: Text('Next'),
                          ),
                        // Show a submit button on the last question
                        if (currentIndex == questions.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              // Calculate the score

                              userAnswers[currentIndex] =
                                  answerController.text.trim();
                              int score = 0;
                              for (int i = 0; i < questions.length; i++) {
                                if (userAnswers[i].toLowerCase() ==
                                    answers[i].toLowerCase()) {
                                  score++;
                                  //print(answerController.text);
                                }
                              }
                              // Show the score in an alert dialog

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Quiz Complete'),
                                    content: Text(
                                        'Your score: $score / ${questions.length}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // //TESTING MOVING FROM SCREEN TO SCREEN
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => HelloPage()),
                              //  );
                            },
                            child: Text('Submit'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:kwiz/hello.dart';
// import 'package:kwiz/firebase_options.dart';
// import 'package:kwiz/services/database.dart';

// import 'Models/Quizzes.dart';

// class QuizScreen extends StatefulWidget {
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   DatabaseService service = DatabaseService();
//   // Get the questions from firebase

//   Quiz? quiz;
//   late bool _isLoading;

//   int quizLength = 0;

//   Future<void> loaddata() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       quiz = await service.getQuizAndQuestions(QuizID: 'IXB6iGJugaXnMDc1rwdn');

//       quizLength = quiz!
//           .QuizQuestions.length; //this seemed to have fixed the null error?
//       popList(quiz);
//     } catch (e) {
//       print('$e');
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     loaddata();
//     super.initState();
//   }

//   void popList(Quiz? q) {
//     for (int i = 0; i < quizLength; i++) {
//       questions[i] = (q!.QuizQuestions.elementAt(i).QuestionText);
//       answers[i] = (q!.QuizQuestions.elementAt(i).QuestionAnswer);
//     }
//     // for (int i = 0; i < quizLength; i++) {
//     //   questions.add(q!.QuizQuestions.elementAt(i).QuestionText);
//     //   answers.add(q!.QuizQuestions.elementAt(i).QuestionAnswer);
//     // }
//   }

//   // void popList(Quiz? q){
//   //     for (int i = 0; i <quizLength; i++){
//   //       questions.add(q!.QuizQuestions.elementAt(i).QuestionText);
//   //       answers.add(q.QuizQuestions.elementAt(i).QuestionAnswer);
//   //     }
//   //   }

//   List<String> questions = [];
//   List<String> answers = [];

//   // Controller for the answer input field
//   TextEditingController answerController = TextEditingController();

//   //user input answers
//   List<String> userAnswers = List.filled(3, ''); //make this dynamic!!!

//   //get quizname from firebase
//   final String quizName = 'PlaceHolder :)';

//   // Index of the current question
//   int currentIndex = 0;

//   // final Future<Quiz?> quiz = loaddata();

//   @override
//   Widget build(BuildContext context) {
//     void updateText() {
//       answerController.text = userAnswers[currentIndex];
//     }

//     // questions = List.filled(3, ''); //the hardcoded works but crashes
//     // answers = List.filled(3, ''); //initialise size of answer and question list

//     // popList(quiz);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             quizName), // save the title as a global variabe thats pulled from firebase as well
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     flex: 1,
//                     fit: FlexFit.tight,
//                     child: Image.asset('assets/images/geo1.jpg'),
//                   ),
//                   // Display the question number and question text

//                   TextButton(
//                     onPressed: () {
//                       print(quiz!.QuizQuestions.elementAt(1).QuestionText);
//                       print(currentIndex);
//                     },
//                     child: Text('Get Quiz with Questions'),
//                   ),

//                   Text(
//                     'Question ${currentIndex + 1} of ${questions.length}', //
//                     style:
//                         TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     questions[currentIndex],
//                     style:
//                         TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 32.0),
//                   // Input field for the answer

//                   TextField(
//                     controller: answerController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your answer here',
//                       hintStyle:
//                           TextStyle(color: Color.fromARGB(255, 107, 106, 106)),
//                     ),
//                   ),

//                   SizedBox(height: 32.0),
//                   // Buttons for moving to the previous/next question
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       if (currentIndex > 0)
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               currentIndex--;
//                               updateText();
//                               //print(currentIndex);
//                               //answerController.clear();
//                             });
//                           },
//                           child: Text('Previous'),
//                         ),
//                       if (currentIndex < questions.length - 1)
//                         ElevatedButton(
//                           onPressed: () {
//                             userAnswers[currentIndex] =
//                                 answerController.text.trim();
//                             /////userAnswers.add(answerController.text.trim());
//                             // print(userAnswers);
//                             setState(() {
//                               currentIndex++;
//                               updateText();
//                               //print(currentIndex);
//                               //answerController.clear();
//                             });
//                           },
//                           child: Text('Next'),
//                         ),
//                       // Show a submit button on the last question
//                       if (currentIndex == questions.length - 1)
//                         ElevatedButton(
//                           onPressed: () {
//                             // Calculate the score

//                             userAnswers[currentIndex] =
//                                 answerController.text.trim();
//                             int score = 0;
//                             for (int i = 0; i < questions.length; i++) {
//                               if (userAnswers[i].toLowerCase() ==
//                                   answers[i].toLowerCase()) {
//                                 score++;
//                                 //print(answerController.text);
//                               }
//                             }
//                             // Show the score in an alert dialog

//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Quiz Complete'),
//                                   content: Text(
//                                       'Your score: $score / ${questions.length}'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: Text('OK'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );

//                             // //TESTING MOVING FROM SCREEN TO SCREEN
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(builder: (context) => HelloPage()),
//                             //  );
//                           },
//                           child: Text('Submit'),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// //USE WIDGET INSPECTOR type Ctrl + T and search >Dart: Open DevTools
// //Flex makes it "become small" can be squashed :) the picture of the globe is squashed when we click on input box.

// /*PROBLEMS:
//         >> [SOLVED :D] texteditingcontroller is the same for all questions.
//                 ...do i create new tec for each question?
//         >> [SOLVED :D] want text to remain when i press previous but only one answer saved?????
//         >> [SOLVED] having trouble adding comparing userAnswers and answer lists.
//         >> [SOLVED] set flex for picture perma

// */

// //add the data pulled into a list and work with the list instead
