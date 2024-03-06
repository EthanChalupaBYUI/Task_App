import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//? Entrance to app
void main() {
  runApp(MyApp());
}

//? Sets up app as a material theme app, initializes HomePage
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

//? stupid nesting for HomePageState
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

//? Main page. Finally something real.
class HomePageState extends State<HomePage> {
  List<Submission> submissions = [];

  //? adds and deletes from submission list. Submission is a class that is basically a struct.
  void addSubmission(String text, String desc, DateTime date) {
    setState(() {
      submissions.add(Submission(text: text, desc: desc, date: date));
    });
  }

  void deleteSubmission(int index) {
    setState(() {
      submissions.removeAt(index);
    });
  }

  //? You hav to override the constructors for flutter classes, seems dumb to me.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //? Header
      appBar: AppBar(
        title: const Text('Task List App'),
      ),
      //? list of tasks
      body: ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          return ListItem(
            submission: submissions[index],
            onDelete: () {
              deleteSubmission(index);
            },
          );
        },
      ),
      //? Plus button to add items
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateModal(
                onSubmit: (title, desc, date) {
                  addSubmission(title, desc, date);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//? List item 
class ListItem extends StatelessWidget {
  final Submission submission;
  final VoidCallback onDelete;

  const ListItem({required this.submission, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(submission.text),
      subtitle: Container(
          padding: const EdgeInsets.all(20.0),
          // margin: const EdgeInsets.symmetric(horizontal: 50.0),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(20.0),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(submission.desc),
            Text(DateFormat('yyyy-MM-dd').format(submission.date)),
          ])),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}

class Submission {
  final String text;
  final DateTime date;
  final String desc;

  const Submission(
      {required this.text, required this.date, required this.desc});
}

class CreateModal extends StatefulWidget {
  final Function(String, String, DateTime) onSubmit;

  const CreateModal({required this.onSubmit});

  @override
  CreateModalState createState() => CreateModalState();
}

class CreateModalState extends State<CreateModal> {
  String titleText = '';
  String descText = '';
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Task',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  titleText = value;
                },
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value2) {
                  descText = value2;
                },
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedDate.toLocal()}'.split(' ')[0],
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Icon(Icons.calendar_month_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(titleText, descText, selectedDate);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
