import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: prefer_const_constructors
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kwiz/classes/QA.dart';
import 'package:kwiz/classes/multiLineTextField.dart';

class QAContainer extends StatefulWidget {
  // we can pass any input when instantiating the class so we can do this
  Function delete;
  final Key? key;
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  // make private index variable, for index of widget in parent list
  int? number;

  QAContainer({required this.delete, required this.key, int? number})
      : super(key: key) {
    // set the optional parameter if no value is provided
    this.number = number ?? 0;
  }

  QA extractQA() {
    return QA(
        question: _questionController.text, answer: _answerController.text);
  }

  @override
  State<QAContainer> createState() => _QAContainerState();
}

class _QAContainerState extends State<QAContainer> {
  @override
  // void dispose() {
  //   // Dispose the controllers when the widget is disposed
  //   widget._questionController.dispose();
  //   widget._answerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  /* calls widget.delete for this widget. It's like using this.delete and this.key except that changes for stateful widgets. */
                  widget.delete(widget.key);
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: SizedBox(
                height: 100,
                child: TextField(
                  controller: widget._questionController,
                  minLines: 3,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Question ${widget.number}',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Question ${widget.number}',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ))),
                )),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.white,
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Flexible(
                  child: TextField(
                    controller: widget._answerController,
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Answer',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        hintText: 'Answer',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ))),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
