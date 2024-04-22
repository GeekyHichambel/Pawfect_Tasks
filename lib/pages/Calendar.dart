import 'package:PawfectTasks/Components/Animations.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';

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

class CalendarState extends State<Calendar>{
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
          child: SingleChildScrollView(
            physics: const RangeMaintainingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(delay: 1,
                    child:  Text('🔥 Streak Calendar',style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyBlack , fontSize: 24, fontWeight: FontWeight.w700),)),
                const SizedBox(height: 10.0,),
                FadeInAnimation(delay: 1.25,
                    child: CustomCalendarViewer(
                          startYear: 2024,
                          endYear: 2030,
                          calendarStartDay: CustomCalendarStartDay.sunday,
                          activeColor: AppTheme.colors.lightBrown,
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
                        )
                    ),
              ],
            ),
          )
        ),
      )
    );
  }
}