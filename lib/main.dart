import 'package:task_manager/homescreen.dart';
import 'package:task_manager/login.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'AFqE5PgDoxSpF4QQvzaWeaDNyef3u1OnmlBXK31A';
  const keyClientKey = 'vNwAhH3xxlBYcmYE8ti1bmxqLMpDm1DvJQbNOTft';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Task Manager',
      theme: ThemeData(
       // primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 194, 166, 166), // Set your desired background color
        body: Login(), // Replace with your HomePage widget
      ),
    );
  }
}
