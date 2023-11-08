import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steeple_chase_app/models/course_model.dart';
import 'package:steeple_chase_app/models/questions_model.dart';
import 'package:steeple_chase_app/screens/add_Questions_page.dart';


import 'screens/homepage.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: MultiProvider(
          providers: [
            Provider<Questions>(
              create: (_) => Questions(),
            ),
            Provider.value(
              value: Course(),
            ),
            Provider(
              create: (context) => TimeCount(),
            )
          ],
          builder: (context, child) => const HomePage(),
        ),
        routes: {
          AddQuestionPage.routeName: (context) => const AddQuestionPage(),
        
     
        });
  }
}
