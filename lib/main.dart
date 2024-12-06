import 'package:bucket_list/bucket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BucketService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Consumer<BucketService>(builder: (context, bucketService, child) {
      List<Bucket> bucketList = bucketService.bucketList;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Bucket list",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: bucketList.isEmpty
            ? const Center(
                child: Text(
                  "Bucket is Empty",
                ),
              )
            : ListView.builder(
                itemCount: bucketList.length,
                itemBuilder: (context, index) {
                  Bucket bucket = bucketList[index];
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
                          bucketService.updateBucket(bucket, index);
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
                bucketList.add(newBcuket);
              });
            }
          },
        ),
      );
    });
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
                  // bucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.pink),
              ),
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
                    BucketService bucketService = context.read<BucketService>();
                    bucketService.createBucket(job);
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
