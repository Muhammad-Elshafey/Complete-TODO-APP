import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectone/shared/components/components.dart';
import 'package:projectone/shared/cubit/cubit.dart';
import 'package:projectone/shared/cubit/states.dart';

import '../../shared/components/constans.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<CubitApp , AppStates>(
      listener: (context , state){},
      builder: (context , state)
      {
        var tasks = CubitApp.get(context).doneTasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
