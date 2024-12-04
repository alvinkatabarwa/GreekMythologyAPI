import 'package:flutter/material.dart';
import 'greek_gods_list.dart'; // Update import name
import 'god_details.dart'; // Update import name

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greek Gods',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Changed from pink to match typical Greek theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  GreekGodListPage(), // Updated home page
      routes: {
        '/godsList': (context) => GreekGodListPage(),
        '/godDetail': (context) => GodDetailPage(
            godData: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
