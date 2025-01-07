import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  DBhelper._();
  static final DBhelper dbInstace = DBhelper._();
  
  Database? myDB;

  // Create or Open the DB
  Future<Database> getDB()async{
    if(myDB!=null){ return myDB!;}
    else {
      myDB = await openDB();
      return myDB!;
      }
  }
  Future<Database> openDB() async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "todo1.db");
    return await openDatabase(dbPath, onCreate: (db, version){
      // Create Table
      db.execute("CREATE Table todo (s_no integer primary key autoincrement, title text, desc text, status integer)");
      db.execute("CREATE TABLE media (id INTEGER PRIMARY KEY autoincrement, title TEXT, image Uint8List, type TEXT)");
    },version: 1);
  }

  // DB Queries
  Future<bool> insertData({required String myTitle, required String myDesc})async{
    var db = await getDB();
    int rowsEffected = await db.insert('todo', {
      "title": myTitle,
      "desc": myDesc,
      "status": 1
    });
    return rowsEffected>0;
  }

  Future<List<Map<String,dynamic>>> showData() async{
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query('todo');
    return mData;
  }

  Future<bool> updateData({required int id, required int statusid}) async{
    var db = await getDB();
    int rowsEffected = await db.update('todo', {
      'status': statusid
    }, where: "s_no=$id");
    return rowsEffected>0;
  }

  Future<bool> deleteData({required int id}) async{
    var db = await getDB();
    int rowsEffected = await db.delete('todo', where: "s_no=?", whereArgs: [id]);
    return rowsEffected>0;
  }


  // Image/Videos Queries
  Future<bool> insertPicture({required String title, required String image, required String type}) async {
  var db = await getDB();
  int rowsEffected = await db.insert("media", {
    'title': title,
    'image': image,
    'type': type
  });
  return rowsEffected>0;
}

Future<List<Map<String,dynamic>>> showPictures() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query('media');
    return mData;
  }

  Future<bool> deletePicture({required int id}) async{
    var db = await getDB();
    int rowsEffected = await db.delete('media', where: "id=?", whereArgs: [id]);
    return rowsEffected>0;
  }

Future close() async{
  var db = await getDB();
  db.close();
}
}