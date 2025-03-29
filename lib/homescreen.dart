import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:task_manager/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks(); 
  }

  Future<void> fetchTasks() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Task'));
    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        tasks = response.results as List<ParseObject>;
      });
    }
  }

  Future<void> addTask(String title, String description) async {
    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', description);
    final response = await task.save();

    if (response.success) {
      fetchTasks(); 
    }
  }

  Future<void> editTask(
      ParseObject task, String updatedTitle, String updatedDescription) async {
    task
      ..set('title', updatedTitle)
      ..set('description', updatedDescription);
    final response = await task.save();

    if (response.success) {
      fetchTasks(); 
    }
  }

  Future<void> deleteTask(ParseObject task) async {
    final response = await task.delete();

    if (response.success) {
      setState(() {
        tasks.remove(task);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error deleting task: ${response.error?.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Home Page'), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            logoutUser(context);
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController descriptionController =
                  TextEditingController();
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addTask(
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final taskTitle = task.get<String>('title') ?? 'Unnamed Task';
          final taskDescription =
              task.get<String>('description') ?? 'No Description';

          return ListTile(
            title: Text(taskTitle),
            subtitle: Text(taskDescription),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController titleController =
                            TextEditingController(text: taskTitle);
                        TextEditingController descriptionController =
                            TextEditingController(text: taskDescription);
                        return AlertDialog(
                          title: const Text('Edit Task'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                editTask(
                                  task,
                                  titleController.text.trim(),
                                  descriptionController.text.trim(),
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(task);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    // Get the current user
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;

    // Check if the user is logged in
    if (currentUser != null) {
      // Perform logout
      final response = await currentUser.logout();

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout successful!')),
        );

        // Navigate back to the LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error during logout: ${response.error?.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently logged in.')),
      );
    }
  }
}
