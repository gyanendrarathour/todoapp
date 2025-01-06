import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/themeProvider.dart';
import 'package:todoapp/view/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context)=>ThemeProvider())
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(    
      builder: (BuildContext context) {
        final settings = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // themeMode: ThemeMode.system,
          theme: settings.currentTheme,
          // darkTheme: ThemeData.dark(),
          home: const HomeScreen(),
        );
      }
    );
  }
}