import 'dart:convert';

import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Components/AppTheme.dart';
import '../../Components/indicator.dart';
import '../../GLOBALS.dart';

class killM extends StatefulWidget{
  const killM({Key? key}) : super(key: key);
  @override
  killMState createState() => killMState();
}

class killMState extends State<killM>{
  double occupiedSpace = 0;
  double availableSpace = 0;

  Future<void> getSize() async{
    if (await Globals.prefs.read(key: 'tasks') != null){
      final jsonString = await Globals.prefs.read(key: 'tasks');
      final int totalSize = utf8.encode(jsonString!).length;
      const int totalBytes = 2147483648;
      setState(() {
        occupiedSpace = (totalSize/totalBytes) * 100;
        availableSpace = 100 - occupiedSpace;
        if (kDebugMode) {
          print(totalSize/1024);
        }
      });
  }
  }

  Future<void> backupTasks() async{
    try{
      if (Globals.LoggedIN) {
        final jsonString = await Globals.prefs.read(key: 'tasks');
        final jsonString2 = await Globals.prefs.read(key: 'tasksCompleted');
        await DataBase.userCollection
            ?.child(Globals.user)
            .ref
            .update({
            'backUpTasks' : jsonString,
            'backUpTasksCompleted' : jsonString2,
        });
      }
      GlobalVar.globalVar.showToast('Backup complete');
    }catch (e){
      if (kDebugMode) print('Exception: $e');
    }
  }

  Future<void> restoreTasks() async{
    try {
      if (Globals.LoggedIN) {
        final ref = await DataBase.userCollection?.child(Globals.user).get();
        if (ref!.hasChild('backUpTasks') && ref.hasChild('backUpTasksCompleted')) {
          final jsonString = ref
              .child('backUpTasks')
              .value
              .toString();
          final jsonString2 = ref
              .child('backUpTasksCompleted')
              .value
              .toString();
          if (await Globals.prefs.read(key: 'tasks') != null) {
            await Globals.prefs.delete(key: 'tasks');
          }
          await Globals.prefs.write(key: 'tasks', value: jsonString);
          await Globals.prefs.write(key: 'tasksCompleted', value: jsonString2);
          GlobalVar.globalVar.showToast('Backup successfully restored');
        } else {
          GlobalVar.globalVar.showToast('There\'s no backup to restore');
        }
      }
    }catch (e){
      if (kDebugMode) print('Exception: $e');
    }
  }

  Future<void> clearTasks() async{
    try{
      bool loading = false;

      await showDialog(context: context, builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return SizedBox(height: 300,
              child: AlertDialog(
                elevation: 0,
                scrollable: true,
                alignment: Alignment.center,
                contentPadding: const EdgeInsets.all(20),
                backgroundColor: AppTheme.colors.friendlyBlack,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16))),
                content: Column(
                  children: [
                    Text('Continuing will delete all the saved data\n\nAre you sure about it?', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.colors.friendlyWhite),),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loading==true? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) : ElevatedButton(onPressed: () async {
                          setState((){
                            loading = true;
                          });
                          if (await Globals.prefs.read(key: 'tasks') != null && await Globals.prefs.read(key: 'tasksCompleted') != null){
                            await Globals.prefs.delete(key: 'tasks');
                            await Globals.prefs.delete(key: 'tasksCompleted');
                            Globals.AllTasks = {

                            };
                            Globals.tasksCompletedToday = 0;
                            Globals.tasks = [];
                            Globals.taskCompleted = {};
                            Globals.displayTasks = [];
                          }
                          setState((){
                            loading = false;
                          });
                          GlobalVar.globalVar.showToast('Storage cleared successfully');
                          Navigator.of(context).pop();
                        }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                            child: const Text('Confirm', style: TextStyle(color: Colors.green),)),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red),))
                      ],
                    ),
                  ],
                )
              )
          ).animate(effects: [
            FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
            ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
          ]);
        });
      });
    }catch (e){
      if (kDebugMode) print('Exception: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    getSize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(name: 'Storage'),
      ),
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInAnimation(
              delay: 1,
              child: Text('Backup and Restore' ,style: TextStyle(
                fontFamily: Globals.sysFont,
                fontWeight: FontWeight.bold,
                color: AppTheme.colors.onsetBlue,
                fontSize: 16,
              )),
            ),
            const SizedBox(height: 20,),
            FadeInAnimation(
              delay: 1,
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    border: Border.all(color: AppTheme.colors.onsetBlue, strokeAlign: BorderSide.strokeAlignOutside)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Container(
                       decoration: BoxDecoration(
                         border: Border(right: BorderSide(color: AppTheme.colors.onsetBlue))
                       ),
                       child: TextButton(onPressed: (){
                         backupTasks();
                       },style: const ButtonStyle(
                         padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
                       ),
                         child: Text('Backup' ,style: TextStyle(
                         fontFamily: Globals.sysFont,
                         color: AppTheme.colors.complimentaryBlack,
                         fontWeight: FontWeight.bold,
                         fontSize: 12,
                       )),),
                     ),
                      TextButton(onPressed: (){
                        restoreTasks();
                      },style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
                      ),
                        child: Text('Restore' ,style: TextStyle(
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.complimentaryBlack,
                        fontSize: 12,
                      )),)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),
            FadeInAnimation(delay: 1.25,child: Icon(Icons.info_outline_rounded, color: AppTheme.colors.blissCream, size: 24,)),
            const SizedBox(height: 5,),
            FadeInAnimation(
              delay: 1.25,
              child: Text('All the tasks are backed up on the cloud, so you don\'t need to worry about space\n\nNote: You must restart the app after restoring data inorder for the app to reflect changes' ,style: TextStyle(
                fontFamily: Globals.sysFont,
                color: AppTheme.colors.blissCream,
                fontSize: 12,
              )),
            ),
            const SizedBox(height: 20,),
            FadeInAnimation(
              delay: 1.5,
              child: Text('Local Storage' ,style: TextStyle(
                fontFamily: Globals.sysFont,
                color: AppTheme.colors.onsetBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
            ),
            const SizedBox(height: 20,),
          FadeInAnimation(
            delay: 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Indicator(
                  color: AppTheme.colors.onsetBlue,
                  text: 'Occupied',
                  isSquare: false,
                  size: 12,
                  textColor: AppTheme.colors.friendlyBlack,
                ),
                Indicator(
                  color: AppTheme.colors.pukeOrange,
                  text: 'Available',
                  isSquare: false,
                  size: 12,
                  textColor: AppTheme.colors.friendlyBlack,
                ),
              ]),
          ),
            const SizedBox(height: 15,),
            FadeInAnimation(
              delay: 1.5,
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: PieChart(
                        PieChartData(sections: [
                          PieChartSectionData(titlePositionPercentageOffset: 2.1,titleStyle: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.blissCream, fontSize: 10),title: '< 1% occupied',value: occupiedSpace, showTitle: occupiedSpace<1, color: AppTheme.colors.onsetBlue),
                          PieChartSectionData(value: occupiedSpace==0? 100 : availableSpace,showTitle: false, color: AppTheme.colors.pukeOrange),
                        ],
                          sectionsSpace: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    FadeInAnimation(
                      delay: 1.5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            border: Border.all(color: AppTheme.colors.onsetBlue, strokeAlign: BorderSide.strokeAlignOutside)
                        ),
                        child: TextButton(onPressed: (){
                            clearTasks();
                        },style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
                        ),
                          child: Text('Clear' ,style: TextStyle(
                            fontFamily: Globals.sysFont,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.complimentaryBlack,
                            fontSize: 12,
                          )),),
                                  ),
                    ),
                  ],
                )),
            ),
            const SizedBox(height: 15,),
            FadeInAnimation(delay: 1.75,child: Icon(Icons.info_outline_rounded, color: AppTheme.colors.blissCream, size: 24,)),
            const SizedBox(height: 5,),
            FadeInAnimation(
              delay: 1.75,
              child: Text('Clear the task data saved in local storage\nTotal storage size is around 2GB' ,style: TextStyle(
                fontFamily: Globals.sysFont,
                color: AppTheme.colors.blissCream,
                fontSize: 12,
              )),
            ),
          ],
          ),
        ),
    )));
  }
}