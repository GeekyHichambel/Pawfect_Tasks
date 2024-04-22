import 'dart:async';
import 'package:PawfectTasks/Components/CustomElevatedButton.dart';
import 'package:PawfectTasks/pages/FriendsPage.dart';
import 'package:PawfectTasks/pages/Tasks/Tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:PawfectTasks/pages/ProfilePane.dart';
import 'package:PawfectTasks/pages/mypets.dart';
import 'package:PawfectTasks/Components/CustomBottomNavigationBarItem.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../Components/Animations.dart';
import '../Components/OutlinedText.dart';
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

class _HomeState extends State<Home> with TickerProviderStateMixin{
  String currentTime = '';
  String TimeImg = '';
  int pendingTasks = 0;
  int completedTasks = 0;
  int expanded = -1;
  List<Map<String,dynamic>> tasks = [];
  bool isMounted = false;

  @override
    void initState(){
      super.initState();
      isMounted = mounted;
      _getTasks();
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
    setState(() {
      tasks = Globals.displayTasks;
      int count = 0;
      for (var task in Globals.displayTasks){
        task.forEach((key, value) {
          if (key == 'completed'){
            if (value) count++;
          }
        });
      }
      completedTasks = count;
      pendingTasks = tasks.length;
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
          Tasks.addTasks(context).then((_){
            _getTasks();
          });
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
                  fontSize: 20,
                ),
              ),),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FadeInAnimation(delay: 1.5,child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(onPressed: (){
                        Navigator.of(context).pushNamed('/calendar');
                      }, icon: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.colors.complimentaryBlack,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                       alignment: Alignment.center,
                        child: Icon(CupertinoIcons.calendar, color: AppTheme.colors.pleasingWhite, size: 14,),),
                      ),
                    ),
                  RichText(
                    text: TextSpan(
                        text: 'Pending Tasks: ',
                        style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: AppTheme.colors.complimentaryBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '${pendingTasks - completedTasks}',
                            style: TextStyle(
                              fontFamily: Globals.sysFont,
                              color: AppTheme.colors.onsetBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          )
                        ]
                    ),
                  ),],),
              )
            ),
            Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
              child: FadeInAnimation(delay: 1.75,child: CustomBox(
                color: Colors.transparent,
                shadow: Colors.transparent,
                border: Border(
                    top: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    left: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    right: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                    bottom: BorderSide(color: AppTheme.colors.blissCream, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                child: Center(
                    child: pendingTasks > 0 ? Padding(padding: const EdgeInsets.all(5.0),child:ListView.builder(itemCount: pendingTasks,itemBuilder: (context, index){
                      return Padding(padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2.0, top: 2),
                          child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.colors.complimentaryBlack.withOpacity(0.6),
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            border: Border.all(color: AppTheme.colors.blissCream.withOpacity(0.6)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                horizontalTitleGap: 10,
                                tileColor: Colors.transparent,
                                leading: CircleAvatar(
                                  backgroundColor: tasks[index]['color'] ?? AppTheme.colors.onsetBlue,
                                  child: tasks[index]['icon'] == null?  Text('T',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: Globals.sysFont,
                                        color: AppTheme.colors.friendlyWhite,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )) : Icon(tasks[index]['icon'],
                                    color: AppTheme.colors.friendlyWhite,
                                    size: 18,
                                  ),
                                ),
                                title: Text(tasks[index]['name'], style: TextStyle(color: AppTheme.colors.friendlyWhite, fontWeight: FontWeight.w600, fontFamily: Globals.sysFont, fontSize: 15, decoration: tasks[index]['completed']? TextDecoration.lineThrough : null, decorationColor: tasks[index]['color'], decorationThickness: 3), ),
                                subtitle: Text(tasks[index]['startTime'] ?? '', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontFamily: Globals.sysFont, fontSize: 16, decoration: tasks[index]['completed']? TextDecoration.lineThrough : null, decorationColor: tasks[index]['color'], decorationThickness: 2),),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    tasks[index]['completed']? const SizedBox.shrink() : SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: (){
                                          Tasks.completeTask(index, context).then((_){
                                            GlobalVar.globalVar.showToast('Task marked as completed');
                                            _getTasks();
                                          });
                                        },
                                        icon: Icon(CupertinoIcons.check_mark, size: 16, color: AppTheme.colors.friendlyWhite,),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: (){
                                          setState(() {
                                            if (expanded == index){
                                              expanded = -1;
                                            }else {
                                              expanded = index;
                                            }
                                          });
                                        },
                                        icon: Icon(expanded == index? CupertinoIcons.chevron_up : Icons.more_vert_rounded, size: 16, color: AppTheme.colors.friendlyWhite,),
                                      ),
                                    ),
                                  ],
                                )),
                              expanded == index? Padding(padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Text(tasks[index]['duration'] ?? '', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontFamily: Globals.sysFont, fontSize: 12),),
                                      const SizedBox(height: 5,),
                                      Text(tasks[index]['description'].isEmpty? 'No description to display': tasks[index]['description'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: Globals.sysFont,
                                          color: AppTheme.colors.friendlyWhite,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),),
                                      const SizedBox(height: 20,),
                                      SizedBox(
                                        height: 40,
                                        width: 80,
                                        child: CustomElevatedButton(onPress: (){
                                          Tasks.deleteTask(index).then((_){
                                            GlobalVar.globalVar.showToast('Task Deleted');
                                            _getTasks();
                                          });
                                        },
                                            outlineColor: AppTheme.colors.pleasingWhite,
                                            fillColor: AppTheme.colors.complimentaryBlack.withOpacity(0.6),
                                            child: Center(
                                              child: OutlinedText(text: 'Delete', fillColor: Colors.red, outlineColor: AppTheme.colors.friendlyWhite, fontSize: 9,)
                                        )
                                      ),),
                                      const SizedBox(height: 5.0,),
                                    ],
                                  ),) : const SizedBox.shrink(),
                            ],
                          )
                      ));
                    })) : Text('We\'re done for today!', style: TextStyle(color: AppTheme.colors.blissCream, fontWeight: FontWeight.w700, fontFamily: Globals.sysFont),),),
              ),)
            )
            ),
          ],
        ),
      ),
    );

  }
}