// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:kwiz/classes/QA.dart';
import 'package:kwiz/classes/QAwidget.dart';
import 'package:kwiz/classes/aboutCard.dart';
import 'package:kwiz/classes/multiLineTextField.dart';
import 'package:kwiz/Models/Questions.dart';
import 'package:kwiz/Models/Quizzes.dart';
import 'package:kwiz/services/database.dart';

class AddQuestions extends StatefulWidget {
  final String category;
  final String title;
  final String aboutQuiz;

  const AddQuestions(
      {super.key,
      required this.aboutQuiz,
      required this.title,
      required this.category});

  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  List<QAContainer> QAContainers = [];
  List<Question> SavedQAs = [];
  DatabaseService service = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // TODO: Implement category filter
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          QAContainers.clear();
                        });
                      },
                      style: ButtonStyle(),
                      child: Text(
                        'Start over',
                        style: TextStyle(
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        int i = 1;
                        for (var qaContainer in QAContainers) {
                          QA qa = qaContainer.extractQA();

                          Question questionObj = Question(
                              QuestionNumber: i,
                              QuestionText: qa.question,
                              QuestionAnswer: qa.answer,
                              QuestionMark: 0);
                          SavedQAs.add(questionObj);
                          i++;
                        }
                        Quiz quiz = Quiz(
                            QuizName: widget.title,
                            QuizCategory: widget.category,
                            QuizDescription: widget.aboutQuiz,
                            QuizMark: 0,
                            QuizDateCreated: 'QuizDateCreated',
                            QuizQuestions: SavedQAs,
                            QuizID: '');
                        await service.addQuizWithQuestions(quiz);
                      },
                      style: ButtonStyle(),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: QAContainers.length,
                    itemBuilder: (context, index) {
                      QAContainers.elementAt(index).number = index + 1;
                      return QAContainers.elementAt(index);
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final uniqueKey = UniqueKey();
                        QAContainers.add(QAContainer(
                            // when called it takes the parameter of key which is this widgets key
                            // when called on the widget object it can pass its key with widget.key similar to this.key but for stateful objects
                            delete: (key) {
                              setState(() {
                                QAContainers.removeWhere(
                                    (QAContainer) => QAContainer.key == key);
                              });
                            },
                            key: uniqueKey));
                      });
                    },
                    style: ButtonStyle(),
                    child: Text(
                      'Add Question',
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
