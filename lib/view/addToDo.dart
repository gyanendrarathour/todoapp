// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../db/dbHelper.dart';
import 'colors/colors.dart';

class AddToDoScreen extends StatefulWidget {
  const AddToDoScreen({super.key});

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DBhelper? dbHelper = DBhelper.dbInstace;
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      //Insert ToDo Data
      await dbHelper!.insertData(
          myTitle: _titleController.text.toString(),
          myDesc: _descController.text.toString());
          GoRouter.of(context).pushReplacementNamed('home');
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Data Added!!!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        title: const Text(
          'Add ToDo Data',
          style: TextStyle(color: forgroundColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter ToDo Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Plase enter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _descController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Enter ToDo Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Plase enter description';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text('Add Data')),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pushReplacementNamed('home');
                      },
                      child: const Text('Cancel')),
                )
              ],
            )),
      ),
    ));
  }
}
