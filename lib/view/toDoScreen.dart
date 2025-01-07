import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/db/dbHelper.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Map<String, dynamic>> allNotes = [];
  DBhelper? dbHelper;

  getNotes() async {
    allNotes = await dbHelper!.showData();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBhelper.dbInstace;
    getNotes();
  }

  deleteData(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure to Delete!!!'),
            actions: [
              TextButton(
                  onPressed: () async{
                    await dbHelper!.deleteData(id: allNotes[index]['s_no']);
                    GoRouter.of(context).pop();
                    getNotes();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Show ToDo Data
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                int status = allNotes[index]['status'];
                int statusId(){
                  if(status==1){return 0;} else {return 1;}
                }
                return InkWell(
                  onTap: ()async{
                    await dbHelper!.updateData(id: allNotes[index]['s_no'], statusid: statusId());
                    getNotes();
                  },
                  child: status == 1 ? Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(allNotes[index]['s_no'].toString()),
                      ),
                      title: Text(allNotes[index]['title']),
                      subtitle: Text(allNotes[index]['desc']),
                      trailing: IconButton(onPressed: ()async{
                        await dbHelper!.deleteData(id: allNotes[index]['s_no']);
                        getNotes();
                      }, icon: const Icon(Icons.delete)),
                    ),
                  ):Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(allNotes[index]['s_no'].toString()),
                      ),
                      title: Text(allNotes[index]['title'], style: const TextStyle(decoration: TextDecoration.lineThrough),),
                      subtitle: Text(allNotes[index]['desc'], style: const TextStyle(decoration: TextDecoration.lineThrough)),
                      trailing: IconButton(onPressed: (){
                        deleteData(index);
                      }, icon: const Icon(Icons.delete)),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Create your ToDo List'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('addToDo');          
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
