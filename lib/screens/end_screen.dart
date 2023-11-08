import 'package:flutter/material.dart';
import 'package:steeple_chase_app/constants/values.dart';
import 'package:steeple_chase_app/models/course_model.dart';
import 'package:steeple_chase_app/screens/listofquestionineach_page.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({Key? key, required this.ctx, required this.topic})
      : super(key: key);
  final BuildContext ctx;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SECTION ENDED',
              style: whiteTextStyle,
            ),
            TextButton(
              child:const Text(
                'HOME',
                style: whiteTextStyle,
              ),
              onPressed: () {
                Navigator.of(ctx).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        ListOfQuestionPage(topic: topic, ctx: ctx),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
