import 'dart:async';
import 'package:PawfectTasks/pages/FriendsPage.dart';
import 'package:PawfectTasks/pages/Tasks/Tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:PawfectTasks/pages/ProfilePane.dart';
import 'package:PawfectTasks/pages/mypets.dart';
import 'package:PawfectTasks/Components/CustomBottomNavigationBarItem.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../Components/Animations.dart';
import 'marketplace.dart';


class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  static const Pages = [Home(), FriendPage(), MyPet(), MarketPlace()];
  var pageC = PageController();
  int selectedIndex = 0;
  int StreakDays = 0;
  String UserName = '';

  @override
  void initState(){
    super.initState();
    _getStreak();
    _getUserName();
  }

  void _getStreak() async{
    int streak = 0;
    if (Globals.LoggedIN){
        final snapshot = await DataBase.streakCollection?.child(Globals.user).child('streaks').get();
        if (snapshot?.value != null) {
          streak = snapshot?.value as int;
        }
    }
    setState(() {
      StreakDays = streak;
    });
  }

  void _getUserName() async{
    String Name = '';
    if(Globals.LoggedIN){
      Name = Globals.user;
      if (Name.length > 8){
        Name = '${Name.substring(0, 5)}...';
      }
    }
    setState(() {
      if (Name.isEmpty){
        UserName = 'Fella';
      }else{
        UserName = Name;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(child: Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.colors.onsetBlue,
            border: Border(bottom: BorderSide(color: AppTheme.colors.darkOnsetBlue, strokeAlign: BorderSide.strokeAlignInside, width: 2.0))
          ),
          child:Padding(padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 20.0,bottom: 20.0),
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
                          color: AppTheme.colors.friendlyWhite,
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
                    color: AppTheme.colors.friendlyWhite,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
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
                ),
              ],
            )
        ),
      ),),
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
        selectedItemColor: AppTheme.colors.onsetBlue,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        unselectedItemColor: AppTheme.colors.blissCream,
        useLegacyColorScheme: false,
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(Icons.home, ''),
          customNavigationBarItem(Icons.person_add_rounded, ''),
          customNavigationBarItem(Icons.pets_rounded, ''),
          customNavigationBarItem(Icons.shopping_cart_rounded, '')
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
    ));
  }
}

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String currentTime = '';
  String TimeImg = '';
  int pendingTasks = 0;
  List<String> tasks = [];
  bool isMounted = false;

  @override
    void initState(){
      super.initState();
      isMounted = mounted;
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
      isMounted = mounted;
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

  void _updateTime(){
    if (mounted) {
        setState(() {
          currentTime = _getCurrentTime();
        });
      }
    }

   String _getCurrentTime(){
      DateTime now = DateTime.now();
      String period = now.hour < 12 ? 'AM' : 'PM';
      TimeImg = (now.hour >= 6 && now.hour < 12)? 'assets/day_img.png' : (now.hour >= 12 && now.hour < 16)? 'assets/sunny.png' : (now.hour >= 16 && now.hour < 20)? 'assets/eve.png' : 'assets/night_img.png';
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
          Tasks.addTasks(context);
        },overlayColor: const MaterialStatePropertyAll<Color?>(Colors.transparent),
        splashColor: Colors.transparent,
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
        backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20,end: 20,bottom: 20,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          Text('Time', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, ),),
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
            const SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.all(16.0),
              child: FadeInAnimation(delay: 1.25,child: Text(
                'My Tasks',
                style: TextStyle(
                  fontFamily: Globals.sysFont,
                  color: AppTheme.colors.friendlyBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),),
            ),
            Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
              child: FadeInAnimation(delay: 1.5,child: CustomBox(
                color: AppTheme.colors.friendlyWhite,
                shadow: Colors.transparent,
                border: Border(
                    top: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    left: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    right: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    bottom: BorderSide(color: AppTheme.colors.blissCream, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                child: Center(
                    child: Text((pendingTasks > 0) ? '$pendingTasks' : 'We\'re done for today!', style: TextStyle(color: AppTheme.colors.blissCream, fontWeight: FontWeight.w700),),),
              ),)
            )
            ),
          ],
        ),
      ),
    );
  }
}