import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectone/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_screen/archived_screen.dart';
import '../../modules/done_screen/done_screen.dart';
import '../../modules/new_tasks_screen/task_screen.dart';

class CubitApp extends Cubit<AppStates> {
  CubitApp() : super(InitialState());
  static CubitApp get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];





  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());

  }

  void createDatabase() {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
     {
       database = value;
       emit(AppCreateDataBase());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
      await database?.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDataBase());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  void getDataFromDatabase(database) async {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];


    emit(AppGetLoadingFromDataBase());
    database!.rawQuery('SELECT * FROM tasks').then((value) {

      
      value.forEach((element)
      {
        if(element['status'] == 'new')
          {
            newTasks.add(element);
          }
        else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        }
        else
        {
          archivedTasks.add(element);
        }
      });
      
      emit(AppGetFromDataBase());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeFLActionBottom({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheet());
  }

   void updateDataBase({
    required String status,
     required int id,
}) async
  {
         database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
         ).then((value)
         {
           getDataFromDatabase(database);
           emit(AppUpdateDataBase());
         });
  }


  void deleteDataBase({
    required int id,
  }) async
  {
    database?.rawUpdate('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDataBase());
    });
  }




}
