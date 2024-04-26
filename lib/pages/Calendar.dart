import 'package:PawfectTasks/Components/Animations.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../Components/AppTheme.dart';
import '../Components/CustomAppBar.dart';
import '../GLOBALS.dart';

class Calendar extends StatefulWidget{
  const Calendar({
    Key? key,
  }) : super(key: key);

  @override
  CalendarState createState() => CalendarState();
}

class TaskLists {
  final List<Map> completedList;
  final List<Map> uncompletedList;

  TaskLists(this.completedList, this.uncompletedList);

  bool get isEmpty {
    if (completedList.isEmpty && uncompletedList.isEmpty) {
      return true;
    }
    else {
      return false;
    }
  }
}

class CalendarState extends State<Calendar>{
  DateTime currentDate = DateTime.now();
  ScrollController sIController = ScrollController();

  Future<TaskLists> loadTasks(DateTime day) async{
    final String selectedDate = DateFormat('yyyy-MM-dd').format(day);

    if (kDebugMode) print(selectedDate);

    if (!Globals.AllTasks.containsKey(selectedDate)){
      return TaskLists([], []);
    }

    final List<dynamic> tasks = Globals.AllTasks[selectedDate];
    final List<Map<String,dynamic>> fullList = tasks.map<Map<String,dynamic>>((dynamic map) {
      return Map<String,dynamic>.from(map).map((key,value){
        if (key == 'icon'){
          if (value != null) {
            IconData iconData = IconData(
                int.parse(value), fontFamily: 'MaterialIcons');
            return MapEntry<String, dynamic>(key, iconData);
          }else{
            return MapEntry<String, dynamic>(key, null);
          }
        }else if (key == 'color') {
          if (value != null) {
            Color color = Color(int.parse(value));
            return MapEntry<String, dynamic>(key, color);
          } else{
            return MapEntry<String, dynamic>(key, null);
          }
        }else if (key == 'completed') {
          if (value == 'false'){
            return MapEntry<String,dynamic>(key, false);
          }else{
            return MapEntry<String,dynamic>(key, true);
          }
        }else {
          return MapEntry<String,dynamic>(key, value);
        }
      });
    }).toList();
    List<Map> completedList = [];
    List<Map> uncompletedList = [];
    for (var task in fullList){
      if (task['completed']){
        completedList.add(task);
      }else{
          uncompletedList.add(task);
        }
      }
    return TaskLists(completedList, uncompletedList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        backgroundColor: AppTheme.colors.friendlyWhite,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomAppBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(delay: 1,
                    child:  Text('🔥 Streak Calendar',style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyBlack , fontSize: 24, fontWeight: FontWeight.w700),)),
                const SizedBox(height: 10.0,),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.colors.friendlyWhite,
                    border: Border(bottom: BorderSide(color: AppTheme.colors.gloryBlack, width: 2))
                  ),
                  child: FadeInAnimation(delay: 1.25,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CustomCalendarViewer(
                            calendarType: CustomCalendarType.date,
                            startYear: 2024,
                            endYear: 2030,
                            calendarStartDay: CustomCalendarStartDay.sunday,
                            activeColor: AppTheme.colors.darkOnsetBlue,
                            calendarBorderWidth: 4,
                            spaceBetweenMovingArrow: 20,
                            headerBackground: Colors.transparent,
                            dropDownYearsStyle: TextStyle(color: AppTheme.colors.onsetBlue),
                            currentDayBorder: Border.all(color: AppTheme.colors.onsetBlue),
                            inActiveStyle: TextStyle(color: AppTheme.colors.friendlyBlack),
                            daysBodyBackground: Colors.transparent,
                            daysHeaderBackground: Colors.transparent,
                            dayNameStyle: TextStyle(color: AppTheme.colors.onsetBlue, fontSize: 12),
                            closedDatesColor: AppTheme.colors.friendlyWhite,
                            calendarBorderColor: AppTheme.colors.blissCream,
                            calendarBorderRadius: 16,
                            onDayTapped: (day){
                              setState(() {
                                currentDate = day;
                              });
                            }
                        )
                      ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<TaskLists>(future: loadTasks(currentDate), builder: (context, snapshot){
                   if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                     return Center(
                         child: SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,)
                     );
                   }else if (!snapshot.hasData || snapshot.data!.isEmpty){
                     return Center(
                       child: Text('No data to Display',
                         style: TextStyle(
                             color: AppTheme.colors.blissCream,
                             fontWeight: FontWeight.w700),),
                     );
                   }else{
                     return ScrollbarTheme(
                         data: ScrollbarThemeData(
                           crossAxisMargin: 2,
                           mainAxisMargin: 8,
                           radius: const Radius.circular(16.0),
                           thumbVisibility: const MaterialStatePropertyAll<bool>(true),
                           trackVisibility: const MaterialStatePropertyAll<bool>(true),
                           thumbColor: MaterialStatePropertyAll<Color>(AppTheme.colors.blissCream),
                           trackColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                           trackBorderColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                         ),
                         child: Scrollbar(
                         radius: const Radius.circular(16.0),
                    controller: sIController,
                    child: SingleChildScrollView(
                         controller: sIController,
                         physics: const AlwaysScrollableScrollPhysics(),
                         child: Padding(padding: const EdgeInsets.only(top: 16, right: 16.0),
                             child:Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                       Text('Completed Tasks', style: TextStyle(
                                       fontFamily: Globals.sysFont,
                                       color: AppTheme.colors.friendlyBlack,
                                       fontWeight: FontWeight.w700,
                                       fontSize: 16,
                                     ),),
                                     const SizedBox(width: 8,),
                                     Icon(Icons.mood_rounded, color: AppTheme.colors.onsetBlue,)
                                   ]
                                 ),
                                 const SizedBox(height: 10,),
                                 snapshot.data!.completedList.isEmpty? Center(
                                   child: Image.asset('assets/empty.png', width: 200, height: 150,),
                                 ) : ListView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: snapshot.data?.completedList.length,itemBuilder: (context, index){
                                     return Padding(
                                       padding: const EdgeInsets.only(bottom: 5.0),
                                       child: ListTile(
                                         tileColor: AppTheme.colors.onsetBlue,
                                         shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.colors.darkOnsetBlue,), borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                         title: Text(snapshot.data?.completedList[index]['name'], textAlign: TextAlign.center,style: TextStyle(
                                           fontFamily: Globals.sysFont,
                                           color: AppTheme.colors.friendlyWhite,
                                         ),),
                                       ));
                                   }),
                                 const SizedBox(height: 15,),
                                 Row(
                                   children: [
                                         Text('Uncompleted Tasks',style: TextStyle(
                                         fontFamily: Globals.sysFont,
                                         color: AppTheme.colors.friendlyBlack,
                                         fontWeight: FontWeight.w700,
                                         fontSize: 16,
                                       ),),
                                        const SizedBox(width: 8,),
                                        Icon(Icons.mood_bad_rounded, color: AppTheme.colors.darkOnsetBlue,)
                                   ]
                                 ),
                                 const SizedBox(height: 10,),
                                 snapshot.data!.uncompletedList.isEmpty? Center(
                                   child: Image.asset('assets/empty.png', width: 200, height: 150,),
                                 ) : ListView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true,itemCount: snapshot.data?.uncompletedList.length,itemBuilder: (context, index){
                                   return Padding(
                                       padding: const EdgeInsets.only(bottom: 5.0),
                                       child: ListTile(
                                     tileColor: AppTheme.colors.darkOnsetBlue,
                                     shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.colors.onsetBlue, width: 0.5), borderRadius: const BorderRadius.all(Radius.circular(16.0))),
                                     title: Text(snapshot.data?.uncompletedList[index]['name'], textAlign: TextAlign.center, style: TextStyle(
                                       fontFamily: Globals.sysFont,
                                       color: AppTheme.colors.friendlyWhite,
                                     ),),
                                   ));
                                 }),
                               ],
                             ))
                     )));
                   }
                 }))
              ],
            ),
          )
        ),
    );
  }
}