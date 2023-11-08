import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:steeple_chase_app/constants/values.dart';
import 'package:steeple_chase_app/models/questions_model.dart';
import 'package:steeple_chase_app/screens/listofquestionineach_page.dart';
import '../models/course_model.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);
  static const routeName = '/add_question_page';

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  late TextEditingController _controller;
  final picker = ImagePicker();

  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final info =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    var courseName = info['coursename'].toString();
    BuildContext ctx = info['context'] as BuildContext;

    File? image = Provider.of<Questions>(ctx).image;

    final Topic topic = Topic(
      nameOfCourse: courseName,
      courseId: '',
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: deepBlueGray,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      ListOfQuestionPage(topic: topic, ctx: ctx),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: deepBlueGray,
          actions: [
            IconButton(
              onPressed: () {
                print('true');
                Provider.of<Questions>(ctx, listen: false)
                    .addQuestion(_controller.text, courseName);

                _controller.clear();
              },
              icon: const Icon(Icons.done),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deck:   $courseName',
                style: whiteTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: screenSize.height / 6,
                    width: screenSize.width / 1.5,
                    child: Stack(children: [
                      if (image != null) Image.file(image),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_photo_alternate_rounded,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () async {
                            Provider.of<Questions>(ctx, listen: false)
                                .pickImage();
                            setState(() {});
                            // var pickedFile = await picker.pickImage(
                            //     source: ImageSource.gallery);
                            // setState(() {
                            //   if (pickedFile != null) {
                            //     _image = File(pickedFile.path);
                            //     image = pickedFile.path;
                            //   }
                            // });
                          },
                        ),
                      )
                    ]),
                  ),
                ],
              ),
              const Text(
                'Question',
                style: whiteTextStyle,
              ),
              Expanded(
                child: TextField(
                  autocorrect: false,
                  keyboardAppearance: Brightness.dark,
                  selectionHeightStyle: BoxHeightStyle.tight,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54),
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLines: null,
                  cursorColor: Colors.white54,
                  cursorWidth: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
