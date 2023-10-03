import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/todo_model.dart';

import 'boxes/boxes.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<TodoModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<TodoModel>();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data[index].title.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  delete(
                                    data[index],
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  editDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString(),
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data[index].description.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Date: ${DateTime.now().day},${DateTime.now().month},${DateTime.now().year}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialogBox();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showDialogBox() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add NOTES'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final data = TodoModel(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final box = Boxes.getData();
                box.add(data);

                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editDialog(
    TodoModel todoModel,
    String title,
    String description,
  ) async {
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit NOTES'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                todoModel.title = titleController.text.toString();
                todoModel.description = descriptionController.text.toString();

                todoModel.save();
                descriptionController.clear();
                titleController.clear();

                Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void delete(TodoModel todoModel) async {
    await todoModel.delete();
  }
}
