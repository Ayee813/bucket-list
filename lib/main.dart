import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Bucket {
  String job;
  bool isDone;
  Bucket(this.job, this.isDone);

  // void myfun() {
  //   print(_job);
  // }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> number = [1, 2];
  List<Bucket> BucketList = [
    Bucket("student", true),
    Bucket("Teacher", false),
    Bucket("Doctor", false),
    Bucket("Farmer", false),
    Bucket("Gamer", true),
    Bucket("Programer", true)
  ];

  // var bucket = Bucket(job, isDone)
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   var bucket = Bucket();
  //   bucket.myfun();
  //   bucket.isDone = false;
  //   print(bucket.isDone);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Bucket list",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: BucketList.isEmpty
          ? const Center(
              child: Text(
                "Bucket is Empty",
              ),
            )
          : ListView.builder(
              itemCount: BucketList.length,
              itemBuilder: (context, index) {
                Bucket bucket = BucketList[index];
                return ListTile(
                  title: Text(
                    bucket.job,
                    style: TextStyle(
                      fontSize: 24,
                      color: bucket.isDone ? Colors.grey : Colors.black,
                      decoration: bucket.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(CupertinoIcons.delete),
                    onPressed: () {
                      showDeleteDialog(context, index);
                    },
                  ),
                  onTap: () {
                    setState(
                      () {
                        bucket.isDone = !bucket.isDone;
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String? job = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePage()),
          );
          if (job != null) {
            setState(() {
              Bucket newBcuket = Bucket(job, false);
              BucketList.add(newBcuket);
            });
          }
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  BucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("None"),
            ),
          ],
        );
      },
    );
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController textEditingController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("INPUT YOUR JOB NAME"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter your Job Name ",
                errorText: error,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 163, 214, 255),
                  iconColor: Colors.green,
                  textStyle: TextStyle(color: Colors.black),
                ),
                label: const Text("Create"),
                icon: const Icon(Icons.add),
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  String job = textEditingController.text;
                  if (job.isEmpty) {
                    setState(() {
                      error = "please enter your job name";
                    });
                  } else {
                    setState(() {
                      error = null;
                    });
                    Navigator.pop(context, job);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
