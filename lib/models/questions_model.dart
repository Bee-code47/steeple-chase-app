import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class Question {
  final String image;
  final String questions;
  final String id;

  Question({required this.image, required this.questions, required this.id});
}

class Questions extends ChangeNotifier {
  var picker = ImagePicker();
  File? image;
  late String imageString;
  final List<Question> _listOfQuestions = [
    // Question(
    //     image: 'assets/image/weed.jpg',
    //     questions: 'what is my name?',
    //     id: 'id1')
  ];

  List<Question> get listOfQuestions {
    return _listOfQuestions;
  }

  pickImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      imageString = pickedFile.path;
      // image = pickedFile.path;
      notifyListeners();
     
    }
  }

  void addQuestion(String questions, String courseName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    final Question newQuestion = Question(
      image: imageString,
      id: courseName + uuid.v4(),
      questions: questions,
    );

    var jsonQuestion = {
      'image': newQuestion.image,
      'id': newQuestion.id,
      'questions': newQuestion.questions
    };
    var questionString = jsonEncode(jsonQuestion);
    var existingItem = prefs.getStringList('questions') ?? [];
    existingItem.add(questionString);
    prefs.remove('questions');
    await prefs.setStringList('questions', existingItem);
    // print(prefs.getStringList('questions'));

    notifyListeners();
  }

  void removeQuestion(String id) {
    _listOfQuestions.removeWhere((question) => question.id == id);
    notifyListeners();
  }
}

class TimeCount extends ChangeNotifier {
  Timer? _countDownTimer;
  final int realTime = 40;
  int counter = 40;

  void startTimer(Function setState) {
    _countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        counter -= 1;
        notifyListeners();
        setState();
      },
    );
  }

  void resetTimer() {
    counter = 40;
    notifyListeners();
  }

  stopTimer() {
    _countDownTimer!.cancel();
  }
}
