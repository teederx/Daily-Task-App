import 'package:daily_tasks_app/provider/projects.dart';
import 'package:daily_tasks_app/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Projects(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black),
            ),
            colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.white,
              background: Colors.white,
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          TasksScreen.routeName: (context) => const TasksScreen(),
        },
      ),
    );
  }
}
