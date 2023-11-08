import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steeple_chase_app/constants/values.dart';
import 'package:steeple_chase_app/models/course_model.dart';
import 'package:steeple_chase_app/models/questions_model.dart';
import 'package:steeple_chase_app/screens/add_Questions_page.dart';
import 'package:steeple_chase_app/screens/questions_screen.dart';

class ListOfQuestionPage extends StatefulWidget {
  const ListOfQuestionPage({
    Key? key,
    required this.topic,
    required this.ctx,
  }) : super(key: key);

  final Topic topic;
  final BuildContext ctx;

  @override
  State<ListOfQuestionPage> createState() => _ListOfQuestionPageState();
}

class _ListOfQuestionPageState extends State<ListOfQuestionPage> {
  final List<Question> _listOfQuestion = [];

  @override
  void initState() {
    numberOfQUestion();
    super.initState();
  }

  void numberOfQUestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var unfilterListOfQuestions = prefs.getStringList('questions');

    for (var question in unfilterListOfQuestions ?? []) {
      Map<String, dynamic> decodedQuestion = json.decode(question);
      if (decodedQuestion['id']!.startsWith(widget.topic.nameOfCourse)) {
        _listOfQuestion.add(
          Question(
            id: decodedQuestion['id'],
            image: decodedQuestion['image'],
            questions: decodedQuestion['questions'],
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: deepBlueGray,
        appBar: AppBar(backgroundColor: deepBlueGray),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.topic.nameOfCourse,
                style: const TextStyle(
                  color: blueGray,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'You have ${_listOfQuestion.length} Question in this Section',
                style: const TextStyle(
                  color: blueGray,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_listOfQuestion.isNotEmpty) {
                    Navigator.of(widget.ctx).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionScreen(
                          ctx: widget.ctx,
                          topic: widget.topic,
                          listOfQuestions: _listOfQuestion,
                        ),
                      ),
                    );
                  } else {
                    showSnackBar(widget.ctx);
                    return;
                  }
                },
                child: const Text(
                  'START SECTION',
                  style: TextStyle(
                    color: blueGray,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AddQuestionPage.routeName,
                    arguments: {
                      'coursename': widget.topic.nameOfCourse,
                      'context': widget.ctx
                    },
                  );
                },
                child: const Text(
                  'ADD QUESTION',
                  style: TextStyle(
                    color: blueGray,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'You do not have any question to practice add some !',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.redAccent),
      ),
    ),
  );
}
