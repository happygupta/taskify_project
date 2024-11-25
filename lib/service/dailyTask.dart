import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:taskify_project/Screens/home/add_task.dart';
import 'package:taskify_project/Screens/home/home.dart';
import 'package:taskify_project/service/Completedscreen.dart';
import 'package:taskify_project/service/Upcoming.dart';

class Dailytask extends StatefulWidget {
  const Dailytask({super.key});

  @override
  State<Dailytask> createState() => _DailytaskState();
}

class _DailytaskState extends State<Dailytask> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Daily Task',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23),),
            backgroundColor: Colors.orange,
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask(isEdit: false, eventData: {},)));
                }
                , icon: Icon(Icons.add,color: Colors.white,),
              ),
            ],
            bottom: TabBar(
                tabs: [
                  Tab(text: "Upcoming",),
                  Tab(text: "Completed",),
                ]
            ),
          ),
        body: TabBarView(
          children: [
            Upcoming(),
            Completedscreen(),
          ],
          ),
        ),
    );
  }
}
