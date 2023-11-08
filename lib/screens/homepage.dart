import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steeple_chase_app/constants/values.dart';
import 'package:steeple_chase_app/models/course_model.dart';
import 'package:steeple_chase_app/screens/listofquestionineach_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  late List<Topic> listOfCourse;

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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Deck'),
        actions: [
          TextButton(
            onPressed: () {
              _showCreateQuestionDialog(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          )
        ],
      ),
    );
  }

  _showCreateQuestionDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create Deck'),
          content: TextField(
            decoration: const InputDecoration(
                hintText: 'Deck Name', focusedBorder: InputBorder.none),
            controller: _controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text.length >= 6) {
                  setState(() {
                    Provider.of<Course>(context, listen: false)
                        .addCourse(_controller.text);
                  });
                  _controller.clear();

                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content:
                          Text('Please enter a name greater than 6 letters'),
                    ),
                  );

                  return;
                }
              },
              child: const Text('Add Card'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueGray,
      body: SafeArea(
        child: FutureBuilder(
            future: Provider.of<Course>(context).retreiveSavedContent(),
            builder: (BuildContext ctx, _) {
              listOfCourse =
                  Provider.of<Course>(context, listen: true).listOfCourse;
              return ListView.builder(
                itemCount: listOfCourse.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ListOfQuestionPage(
                            topic: listOfCourse[index],
                            ctx: ctx,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Deck'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  context.read<Course>().deleteCourse(
                                      listOfCourse[index].courseId,
                                      listOfCourse[index].nameOfCourse);
                                });

                                Navigator.of(context).pop();
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancle'),
                            )
                          ],
                        ),
                      );
                    },
                    textColor: const Color.fromARGB(255, 2, 43, 77),
                    title: Text(
                      listOfCourse[index].nameOfCourse,
                      style: textStyle,
                    ),
                    trailing: Text('${listOfCourse[index].questions.length}'),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueGray,
        child: Icon(
          Icons.add,
          color: deepBlueGray,
        ),
        onPressed: () async {
          _showDialog(context);
        },
      ),
    );
  }
}
