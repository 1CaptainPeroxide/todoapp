// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/data/database.dart';
// ignore: unused_import
import 'package:todoapp/util/todo_tile.dart';

import '../util/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //reference the hive box
  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {

    // if this is the 1st time ever opening the app, then create default data
    if(_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else{
      //there already exists data
      db.loadData();
    }
    super.initState();

  }

  // text controller
  final _controller = TextEditingController();

  //list of to do tasks
  


  //checkbox was tapped

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
       
    });
    db.updateDataBase();
   
  }


  // save a new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
        db.updateDataBase();

  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox (
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(widget),
        );
      }
      );
  }


  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
        db.updateDataBase();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(child: Text('TO DO')),
        elevation: 2,
        backgroundColor: Colors.yellow[500],
      ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.yellow[500],
      onPressed: createNewTask,
      
      child: Icon(Icons.add),
      ),

      body: ListView.builder(
        
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (p0) => deleteTask(index),
            );
        },
      ),
    );
  }
}
