import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/themeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool themeIcon = true;

  void _incrementCounter() {
    final settings = Provider.of<ThemeProvider>(context, listen: false);
    settings.toggleTheme();
    if(themeIcon == true){
      themeIcon = false;
    }
    else{
      themeIcon = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black38,
          title: const Text('Home Screen'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              _incrementCounter();
              setState(() {
                
              });
            }, icon: themeIcon? const Icon(Icons.sunny): const Icon(Icons.dark_mode))
          ],
        ),
      )
    );
  }
}