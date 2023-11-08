
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steeple_chase_app/constants/values.dart';
import 'package:steeple_chase_app/models/course_model.dart';
import 'package:steeple_chase_app/models/questions_model.dart';
import 'package:steeple_chase_app/screens/end_screen.dart';

class QuestionScreen extends StatefulWidget {
  final BuildContext ctx;
  final Topic topic;
  final List<Question> listOfQuestions;

  const QuestionScreen({
    super.key,
    required this.ctx,
    required this.topic,
    required this.listOfQuestions,
  });
  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int questionIndex = 0;
  bool _isStarted = false;

  Color get quesColor {
    if ((widget.listOfQuestions.length - questionIndex) <= 5) {
      return Colors.red;
    } else if ((widget.listOfQuestions.length - questionIndex) < 10) {
      return Colors.green;
    } else {
      return const Color.fromARGB(255, 196, 177, 6);
    }
  }

  Color get progressIndicatorColor {
    if (widget.ctx.read<TimeCount>().counter < 10) {
      return Colors.red;
    } else if (widget.ctx.read<TimeCount>().counter < 20) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final realtime = Provider.of<TimeCount>(widget.ctx, listen: true).realTime;
    final counter = widget.ctx.read<TimeCount>().counter;

    var ques = widget.listOfQuestions[questionIndex];

    if (_isStarted &&
        (questionIndex == widget.listOfQuestions.length - 1) &&
        counter == 0) {
      widget.ctx.read<TimeCount>().stopTimer();
      return EndScreen(ctx: widget.ctx, topic: widget.topic);
    } else if (!_isStarted) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: deepBlueGray,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                        children: [
                          const Text(
                            'TIMER:  ',
                            style: textStyle2,
                          ),
                          Stack(
                            children: [
                              CircularProgressIndicator(
                                value: counter / realtime,
                                color: blueGray,
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Text(
                                  '$counter',
                                  style: countDowntextStyle2,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    
                     Text(
                        '${widget.listOfQuestions.length - questionIndex}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: quesColor),
                      ),
                  
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: blueGray, width: 5),
                  ),
                  child: SizedBox(
                    height: screenHeight / 2,
                    width: screenWidth * 0.95,
                    child: Image.asset(
                      testingImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    _isStarted = !_isStarted;
                    setState(() {});
                    widget.ctx.read<TimeCount>().startTimer(() {
                      setState(() {});
                    });
                  },
                  child: const Text('START', style: btnTextStyle),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      if (counter == 0) {
        widget.ctx.read<TimeCount>().resetTimer();
        questionIndex += 1;
      }

      return SafeArea(
        child: Scaffold(
          backgroundColor: deepBlueGray,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                        children: [
                          const Text(
                            'TIMER:  ',
                            style: textStyle2,
                          ),
                          Stack(
                            children: [
                              CircularProgressIndicator(
                                value: counter / realtime,
                                color: progressIndicatorColor,
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Text(
                                  '$counter',
                                  style: countDowntextStyle2,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    
                    Text(
                        '${widget.listOfQuestions.length - questionIndex}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: quesColor),
                      ),
                    
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: blueGray, width: 5),
                  ),
                  child: SizedBox(
                    height: screenHeight / 2,
                    width: screenWidth * 0.95,
                    child: Image.file(
                      File(ques.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'Questions',
                  style: textStyle2,
                ),
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Text(
                    ques.questions,
                    style: whiteTextStyle,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: blueGray, width: 5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
