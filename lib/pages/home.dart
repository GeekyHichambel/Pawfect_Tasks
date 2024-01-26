import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/Components/CustomBox.dart';
import 'package:hit_me_up/GLOBALS.dart';
import 'package:hit_me_up/pages/ProfilePane.dart';
import 'package:hit_me_up/pages/mypets.dart';
import 'package:hit_me_up/Components/CustomBottomNavigationBarItem.dart';

import '../Components/Animations.dart';


class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  static const Pages = [Home(), MyPet()];
  var pageC = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageView(
        onPageChanged: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        controller: pageC,
        children: Pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.colors.blissCream,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        unselectedItemColor: AppTheme.colors.complimentaryBlack,
        useLegacyColorScheme: false,
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(Icons.home, ''),
          customNavigationBarItem(Icons.pets_rounded, ''),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            pageC.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String currentTime = '';
  String UserName = '';
  String TimeImg = '';
  int StreakDays = 0;
  int pendingTasks = 0;
  List<String> Tasks = [];
  bool isMounted = false;

  @override
    void initState(){
      isMounted = true;
      super.initState();
      _getUserName();
      _getStreak();
      _getTasks();
      _getPendingTasks();
      _updateTime();
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          if (isMounted) {
            _updateTime();
          }else {
            timer.cancel();
          }
        });
    }

  @override
    void dispose(){
      isMounted = false;
      super.dispose();
  }

  void _getTasks(){
    // Fetch the tasks list
  }

  void _getPendingTasks(){
    //calculate pending tasks
    int tasks = 0;
    setState(() {
      pendingTasks = tasks;
    });
  }

  void _getStreak(){
    //fetch streak from db
    int streak = 0;
    setState(() {
      StreakDays = streak;
    });
  }

  void _getUserName() async{
    //fetch name from db
    String Name = '';
    if(Globals.LoggedIN){
      Name = Globals.user;
    }
    setState(() {
      if (Name.isEmpty){
        UserName = 'Fella';
      }else{
        UserName = Name;
      }
    });
  }

  void _updateTime(){
      setState(() {
        currentTime = _getCurrentTime();
      });
    }

   String _getCurrentTime(){
      DateTime now = DateTime.now();
      String period = now.hour < 12 ? 'AM' : 'PM';
      TimeImg = (now.hour >= 6 && now.hour < 18)? 'assets/day_img.png' : 'assets/night_img.png';
      String Hour = '${now.hour}';
      String Minute = '${now.minute}';
      if (now.minute < 10){
        Minute = '0$Minute';
      }
      if (now.hour < 10){
        Hour = '0$Hour';
      }
      return '$Hour:$Minute $period';
   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {

        },
        child: Material(
          elevation: 5.0,
          shape: const CircleBorder(),
          color: AppTheme.colors.onsetBlue, // Background color
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: Center(
              child: Icon(
                Icons.add_circle_outline,
                color: AppTheme.colors.pleasingWhite, // Icon color
                size: 30.0, // Icon size
              ),
            ),
          ),
        ),
      ),
        backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed('/streaks');
                    },
                    child: Row(
                      children: [
                        Text(
                          '$StreakDays',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: Globals.sysFont,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 24,
                          ),
                        ),
                        Image.asset(
                          'assets/streak_icon.png',
                          width: 25,
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Text(
                        'Hi, $UserName',
                        style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 30,
                        ),
                      ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(Animations.animations.customRightSlideIn(const ProfilePane()));
                    },
                    child: Image.asset('assets/profile_icon.png',
                      width: 25,
                      height: 25,
                    )
                  )
                ],
              )
            ),
            const SizedBox(height: 10,),
            FadeInAnimation(delay: 1, child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                color: AppTheme.colors.onsetBlue,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time', style: TextStyle(fontFamily: Globals.sysFont, color: Colors.white60, ),),
                          const SizedBox(height: 8,),
                          Text(currentTime,style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.pleasingWhite , fontSize: 18),)
                        ],
                      ),
                    ),
                    Expanded(child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image.asset(TimeImg,
                            width: 50,
                            height: 50,
                          ),
                        )
                    ))
                  ],
                )
            )),
            const SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.all(16.0),
              child: FadeInAnimation(delay: 1.25,child: Text(
                'My Tasks',
                style: TextStyle(
                  fontFamily: Globals.sysFont,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                ),
              ),),
            ),
            Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
              child: FadeInAnimation(delay: 1.5,child: CustomBox(
                color: AppTheme.colors.complimentaryBlack,
                shadow: AppTheme.colors.blissCream,
                child: Center(
                    child: Text((pendingTasks > 0) ? '$pendingTasks' : 'We\'re done for today 😀')),
              ),)
            )
            ),
          ],
        ),
      ),
    );
  }
}