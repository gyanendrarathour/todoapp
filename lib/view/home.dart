import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view/colors/colors.dart';
import 'package:todoapp/view/mediaScreen.dart';
import 'package:todoapp/view/toDoScreen.dart';
import '../provider/themeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool themeIcon = true;
  List<Widget> screens = [
    const ToDoScreen(),
    const MediaScreen()
  ];

  void _themeChange() {
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
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: backgroundColor,
            title: const Text('ToDo App', style: TextStyle(color: forgroundColor),),
            actions: [
              IconButton(onPressed: (){
                _themeChange();
                setState(() {
                  
                });
              }, icon: themeIcon? const Icon(Icons.sunny, color: forgroundColor,): const Icon(Icons.dark_mode))
            ],
            bottom: const TabBar(
              indicatorColor: forgroundColor,
              labelColor: forgroundColor,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              unselectedLabelColor: forgroundColor,
              unselectedLabelStyle: TextStyle(fontSize: 15),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
              Tab(text: 'ToDo',),
              Tab(text: 'Image',)
            ]),
          ),
          body: TabBarView(children: screens),
        )
      ),
    );
  }
}