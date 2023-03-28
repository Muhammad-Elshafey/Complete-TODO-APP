import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:projectone/shared/cubit/cubit.dart';

Widget defaultButton ({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
            radius,
        ),
      ),
      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
//-------------------------------------------------------
Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? onSubmitted,
  Function? showPass,
  Function? onTaap,
  required Function validate,
  bool onSecure = false,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: onSecure,
  onTap: onTaap as void Function()?,
  onFieldSubmitted: onSubmitted as void Function(String)?,
  validator: validate as String? Function(String?)?,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null? IconButton(
      onPressed: () {
        showPass!();
      },
      icon: Icon(
        suffix,
      ),
    ):null,
    border: OutlineInputBorder(),

  ),
);
// --------------------------------------------------------------------------------
Widget buildTaskItem(Map model , context) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
      children:
      [
        CircleAvatar(
          radius: 40.0,
          child: Text(
              '${model['time']}'
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        IconButton(
            onPressed: ()
            {
              CubitApp.get(context).updateDataBase(
                  status: 'done',
                  id: model['id'],
              );
            },
            icon: Icon(Icons.check_box),
             color: Colors.green,
        ),
        IconButton(
            onPressed: ()
            {
              CubitApp.get(context).updateDataBase(
                status: 'archive',
                id: model['id'],
              );
            },
            icon: Icon(Icons.archive),
             color: Colors.black45,
        ),
      ],
  ),
),
      onDismissed: (direction)
      {
        CubitApp.get(context).deleteDataBase(id: model['id']);
      },
    );


Widget tasksBuilder ({
  required List<Map> tasks,
}) => ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
      itemBuilder: (context,index) => buildTaskItem(tasks[index] , context),
      separatorBuilder: (context,index) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        const [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );