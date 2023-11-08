import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steeple_chase_app/models/questions_model.dart';
import 'package:uuid/uuid.dart';

class Topic {
  final String nameOfCourse;
  final String courseId;

  List<Question> questions = [];

  Topic({
    required this.nameOfCourse,
    required this.courseId,
  });
}

class Course extends ChangeNotifier {
  final List<Topic> _listOfCourse = [];

  List<Topic> get listOfCourse {
    return _listOfCourse;
  }

  addCourse(String nameOfCourse) async {
    var prefs = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    var _topic = Topic(
      nameOfCourse: nameOfCourse,
      courseId: uuid.v4(),
    );

    var topic = {'crsName': _topic.nameOfCourse, 'crsId': _topic.courseId};
    var encodedTopic = json.encode(topic);
    var existingItem = prefs.getStringList('course') ?? [];
    prefs.remove('course');

    existingItem.add(encodedTopic);
    await prefs.setStringList('course', existingItem);

    notifyListeners();
  }

  Future retreiveSavedContent() async {
    var prefs = await SharedPreferences.getInstance();
    _listOfCourse.clear();

    var extractedVal = prefs.getStringList('course') ?? [];

    for (var element in extractedVal) {
      final tp = json.decode(element) as Map<String, dynamic>;

      _listOfCourse.add(
        Topic(
          nameOfCourse: tp['crsName'],
          courseId: tp['crsId'],
        ),
      );

     
    }
    notifyListeners();
  }

  deleteCourse(String id, String courseName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var existingItem = prefs.getStringList('course') ?? [];
    var retrievedList = [];
    List<Question> retrievedQuesList = [];

    prefs.remove('course');
    _listOfCourse.clear();
    for (var element in existingItem) {
      var retrievedItem = json.decode(element);

      retrievedList.add(retrievedItem);
    }

    retrievedList.removeWhere((topic) => topic['crsId'] == id);

    List<String> encodedList = [];

    for (var element in retrievedList) {
      var encodeItem = json.encode(element);
      encodedList.add(encodeItem);
    }

    var existingQues = prefs.getStringList('questions') ?? [];
    prefs.remove('questions');

    for (var question in existingQues) {
      var decodedQues = json.decode(question);
      var retrievedQues = Question(
          image: decodedQues['image'],
          questions: decodedQues['questions'],
          id: decodedQues['id']);
      retrievedQuesList.add(retrievedQues);
    }
    existingQues.clear();
    retrievedQuesList.removeWhere(
      (question) => question.id.startsWith(courseName),
    );

    for (var question in retrievedQuesList) {
      var jsonQuestion = {
        'image': question.image,
        'id': question.id,
        'questions': question.questions
      };
      var encodedQues = json.encode(jsonQuestion);
      existingQues.add(encodedQues);
    }
    prefs.setStringList('questions', existingQues);

    prefs.setStringList('course', encodedList);
    notifyListeners();
  }
}
