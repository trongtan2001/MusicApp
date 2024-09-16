import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/plugin/ThemeProvider.dart';
import 'package:music_app/ui/home/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => ThemeProvider(),
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MusicApp(),
    );
  }

}
