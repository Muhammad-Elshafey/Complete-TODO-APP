import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectone/shared/cubit/cubit.dart';
import 'package:projectone/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/archived_screen/archived_screen.dart';
import '../modules/done_screen/done_screen.dart';
import '../modules/new_tasks_screen/task_screen.dart';
import '../shared/components/components.dart';
import '../shared/components/constans.dart';

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database

class HomeLayout extends StatelessWidget {

  //----------------------------------------------
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  //----------------------------------------------



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CubitApp()..createDatabase(),
      child: BlocConsumer<CubitApp , AppStates>(
        listener: (context , state) {
          if(state is AppInsertToDataBase)
            {
              Navigator.pop(context);
            }
        },
        builder: (context , state)
        {
          CubitApp cubit = CubitApp.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetLoadingFromDataBase,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;
                    //     //
                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Container(
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    color: Colors.grey[100],
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            label: 'Task Title',
                            prefix: Icons.title,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return ('Task Title Must Not Be Empty');
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Task Time Must Not Be Empty');
                                }
                                return null;
                              },
                              onTaap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              }),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              label: 'Task Date',
                              prefix: Icons.calendar_month_outlined,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return ('Task Date Must Not Be Empty');
                                }
                                return null;
                              },
                              onTaap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2024-09-23'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              }),
                        ],
                      ),
                    ),
                  )).closed.then((value) {
                    cubit.changeFLActionBottom(
                        isShow: false,
                        icon: Icons.edit,
                    );
                  });
                  cubit.changeFLActionBottom(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Instance of 'Future<String>'

  // Future<String> getName() async {
  //   return 'Ahmed Ali';
  // }


}


