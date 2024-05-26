import 'dart:async';
import 'dart:convert';
import 'package:PawfectTasks/Components/CustomElevatedButton.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' as flutter_animate;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gif/gif.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';
import 'ThirdPage.dart';

class Tasks{
  static Future<void> rewardUser(BuildContext context) async{
    bool loading = false;
    bool dead = false;

    Future<void> checkDead() async{
      final pet_ref = await DataBase.petsCollection?.child(Globals.user).get();
      int health = pet_ref?.child('petStatus').child('labra/health').value as int;
      if (health == 0) {
        dead = true;
      }
    }

    Future<void> giveRewards() async{
      final streak_ref = await DataBase.streakCollection?.child(Globals.user).get();
      final item_ref = await DataBase.itemCollection?.child(Globals.user).get();

      int xp = streak_ref?.child('xp').value as int;
      xp = xp + 5;
      int pawCoin = item_ref?.child('pawCoin').value as int;
      pawCoin = pawCoin + 30;
      String league = streak_ref!.child('league').value.toString();
      int slot = streak_ref.child('slot').value as int;
      int streak = streak_ref.child('streak').value as int;

      if (!dead) {
        await streak_ref.ref.update({
          'xp': xp,
        });

        await DataBase.leaderboardCollection?.child(league)
            .child('Slot$slot')
            .child(Globals.user)
            .update({
          'xp': xp,
        });
      }

      await item_ref?.ref.update({
        'pawCoin' : pawCoin,
      });

      final map = {
        'xp' : xp,
        'streak' : streak,
      };

      if (xp > 800 && league == 'Rookie'){
        await streak_ref.ref.update({
          'league' : 'Junior',
        });
        final prev_leaderboard_ref = await DataBase.leaderboardCollection?.child('Rookie').child('Slot$slot').child(Globals.user).get();
        await prev_leaderboard_ref?.ref.remove();
        final new_leaderboard_ref = await DataBase.leaderboardCollection?.child('Junior').get();
        final int? slots = new_leaderboard_ref?.children.length;
        final snapshot = await DataBase.leaderboardCollection?.child('Junior').child('Slot$slots').get();
        late final int slotNo;
        if (snapshot!.children.length < 25){
          slotNo = slots!;
        }else{
          slotNo = slots! + 1;
        }
        await new_leaderboard_ref?.child('Slot$slotNo').ref.update({
          Globals.user : map,
        });
      }
      if (xp > 1600 && league == 'Junior'){
        await streak_ref.ref.update({
          'league' : 'Intermediate',
        });
        final prev_leaderboard_ref = await DataBase.leaderboardCollection?.child('Junior').child('Slot$slot').child(Globals.user).get();
        await prev_leaderboard_ref?.ref.remove();
        final new_leaderboard_ref = await DataBase.leaderboardCollection?.child('Intermediate').get();
        final int? slots = new_leaderboard_ref?.children.length;
        final snapshot = await DataBase.leaderboardCollection?.child('Intermediate').child('Slot$slots').get();
        late final int slotNo;
        if (snapshot!.children.length < 25){
          slotNo = slots!;
        }else{
          slotNo = slots! + 1;
        }
        await new_leaderboard_ref?.child('Slot$slotNo').ref.update({
          Globals.user : map,
        });
      }
      if (xp > 2700 && league == 'Intermediate'){
        await streak_ref.ref.update({
          'league' : 'Senior',
        });
        final prev_leaderboard_ref = await DataBase.leaderboardCollection?.child('Intermediate').child('Slot$slot').child(Globals.user).get();
        await prev_leaderboard_ref?.ref.remove();
        final new_leaderboard_ref = await DataBase.leaderboardCollection?.child('Senior').get();
        final int? slots = new_leaderboard_ref?.children.length;
        final snapshot = await DataBase.leaderboardCollection?.child('Senior').child('Slot$slots').get();
        late final int slotNo;
        if (snapshot!.children.length < 25){
          slotNo = slots!;
        }else{
          slotNo = slots! + 1;
        }
        await new_leaderboard_ref?.child('Slot$slotNo').ref.update({
          Globals.user : map,
        });
      }
      if (xp > 4000 && league == 'Senior'){
        await streak_ref.ref.update({
          'league' : 'Elite',
        });
        final prev_leaderboard_ref = await DataBase.leaderboardCollection?.child('Senior').child('Slot$slot').child(Globals.user).get();
        await prev_leaderboard_ref?.ref.remove();
        final new_leaderboard_ref = await DataBase.leaderboardCollection?.child('Elite').get();
        final int? slots = new_leaderboard_ref?.children.length;
        final snapshot = await DataBase.leaderboardCollection?.child('Elite').child('Slot$slots').get();
        late final int slotNo;
        if (snapshot!.children.length < 25){
          slotNo = slots!;
        }else{
          slotNo = slots! + 1;
        }
        await new_leaderboard_ref?.child('Slot$slotNo').ref.update({
          Globals.user : map,
        });
      }
      if (xp > 5500 && league == 'Elite'){
        await streak_ref.ref.update({
          'league' : 'Premier',
        });
        final prev_leaderboard_ref = await DataBase.leaderboardCollection?.child('Elite').child('Slot$slot').child(Globals.user).get();
        await prev_leaderboard_ref?.ref.remove();
        final new_leaderboard_ref = await DataBase.leaderboardCollection?.child('Premier').get();
        final int? slots = new_leaderboard_ref?.children.length;
        final snapshot = await DataBase.leaderboardCollection?.child('Premier').child('Slot$slots').get();
        late final int slotNo;
        if (snapshot!.children.length < 25){
          slotNo = slots!;
        }else{
          slotNo = slots! + 1;
        }
        await new_leaderboard_ref?.child('Slot$slotNo').ref.update({
          Globals.user : map,
        });
      }
    }

    await checkDead();
    await showDialog(
        context: context, builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(height: 300,
                child: AlertDialog(
                    elevation: 0,
                    scrollable: true,
                    alignment: Alignment.center,
                    contentPadding: const EdgeInsets.all(20.0),
                    backgroundColor: AppTheme.colors.friendlyBlack,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(side: BorderSide.none,
                        borderRadius: BorderRadius.all(
                            Radius.circular(16.0))),
                    content: Column(
                      children: [
                        Gif(image: const AssetImage('assets/good-job.gif',),autostart: Autostart.loop, placeholder: (context){
                          return Expanded(child: SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,));
                  },),
                  const SizedBox(height: 20,),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: dead? [
                    Text('You received 30 ', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 14),),
                    Image.asset('assets/pawCoin.png',width: 16,height: 16,),
                  ]: [
                    Text('You received 5 ', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 14),),
                  Image.asset('assets/xp_icon.png',width: 16,height: 16,),
                  Text(' and 30 ', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 14),),
                            Image.asset('assets/pawCoin.png', width: 16, height: 16,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) : CustomElevatedButton(onPress: (){
                          setState((){
                            loading = true;
                          });
                          giveRewards().then((_){
                            setState((){
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          });
                        },child: Center(child: Text('OK',style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 16, fontWeight: FontWeight.bold))),),
                      ],
                    ))).animate(effects: [
              flutter_animate.FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
              flutter_animate.ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
            ]);
          });
    });
  }

  static Future<void> completeTask(int index, BuildContext context) async{
    Globals.tasks[index]['completed'] = 'true';
    Globals.displayTasks[index]['completed'] = true;
    Globals.tasksCompletedToday++;

    if (Globals.LoggedIN && Globals.tasksCompletedToday <= 8) {
      rewardUser(context);
    }

    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await Globals.prefs.delete(key: 'tasks');
    Globals.AllTasks.update(currentDate, (value) => Globals.tasks);
    final jsonMap = jsonEncode(Globals.AllTasks);
    if (kDebugMode) print(Globals.tasks);
    await Globals.prefs.write(key: 'tasks', value: jsonMap);
    await Globals.prefs.delete(key: 'tasksCompleted');
    if (Globals.taskCompleted.containsKey(currentDate)) {
      Globals.taskCompleted.update(
          currentDate, (value) => Globals.tasksCompletedToday);
    }else{
      Globals.taskCompleted[currentDate] = Globals.tasksCompletedToday;
    }
    if (kDebugMode) print(Globals.taskCompleted);
    final jsonmap = jsonEncode(Globals.taskCompleted);
    await Globals.prefs.write(key: 'tasksCompleted', value: jsonmap);
  }

  static Future<void> deleteTask(int index) async{
    Globals.tasks.removeAt(index);
    Globals.displayTasks.removeAt(index);

    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await Globals.prefs.delete(key: 'tasks');
    Globals.AllTasks.update(currentDate, (value) => Globals.tasks);
    final jsonMap = jsonEncode(Globals.AllTasks);
    if (kDebugMode) print(Globals.tasks);
    await Globals.prefs.write(key: 'tasks', value: jsonMap);
  }

  static Future<int> createNewTask(String name, String? description, Duration start, Duration _duration,IconData? icon, Color? color,DateTime _date,{bool reminder = false, int repetition =  1}) async{
    try {
      final String? taskIcon = icon?.codePoint.toString();
      final String? taskColor = color?.value.toString();
      final String taskName = name;
      final String? taskDescription = description;
      final int minDiff = start.inMinutes - (start.inHours*60);
      final String startTime = minDiff >= 10? '${start.inHours} : $minDiff' : '${start.inHours} : 0$minDiff';
      final String duration = '${_duration.inHours} hours. ${_duration.inMinutes - (_duration.inHours * 60)} min.';
      final DateTime date = _date;
      final bool isReminder = reminder;
      int repetitionDays = repetition;
      if (taskName == ''){
        GlobalVar.globalVar.showToast('Task name can\'t be empty');
        throw Exception('Task name can\'t be empty');
      }

      Map<String, dynamic> task = {
        'color': taskColor,
        'icon': taskIcon,
        'name': taskName,
        'description': taskDescription,
        'startTime' : startTime,
        'duration' : duration,
        'completed' : 'false',
        'reminder' : isReminder.toString(),
      };

      Duration parseTime(String timeString) {
        List<String> parts = timeString.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        return Duration(hours: hours, minutes: minutes);
      }

      final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String selectedDate = DateFormat('yyyy-MM-dd').format(date);

      if (currentDate == selectedDate) {
        if (Globals.tasks.isNotEmpty) {
          Globals.tasks.add(task);
          Globals.tasks.sort((a, b) =>
              parseTime(a['startTime']).compareTo(parseTime(b['startTime'])));
        } else {
          Globals.tasks = [task];
        }

        if (Globals.displayTasks.isNotEmpty) {
          Globals.displayTasks.add({
            'color': color,
            'icon': icon,
            'name': name,
            'description': description,
            'startTime': startTime,
            'duration': duration,
            'completed': false,
            'reminder' : reminder,
          });
          Globals.displayTasks.sort((a, b) =>
              parseTime(a['startTime']).compareTo(parseTime(b['startTime'])));
        } else {
          Globals.displayTasks = [{
            'color': color,
            'icon': icon,
            'name': name,
            'description': description,
            'startTime': startTime,
            'duration': duration,
            'completed': false,
            'reminder' : reminder,
          }
          ];
        }

        await Globals.prefs.delete(key: 'tasks');
        if (Globals.AllTasks.containsKey(currentDate)) {
          Globals.AllTasks.update(currentDate, (value) => Globals.tasks);
        } else {
          Globals.AllTasks[currentDate] = Globals.tasks;
        }
      }else{
        await Globals.prefs.delete(key: 'tasks');
        if (Globals.AllTasks.containsKey(selectedDate)){
          final List<Map<String,dynamic>> tasks = Globals.AllTasks[selectedDate];
            tasks.add(task);
            tasks.sort((a, b) =>
                parseTime(a['startTime']).compareTo(parseTime(b['startTime'])));
          Globals.AllTasks.update(selectedDate, (value) => tasks);
        }else{
          Globals.AllTasks[selectedDate] = [task];
        }
      }

      if (Globals.isPremium && reminder){
        final DateTime scheduledTime = DateTime(date.year,date.month,date.day,parseTime(startTime).inHours,parseTime(startTime).inMinutes - (parseTime(startTime).inHours*60));
        await DataBase.schedule(
          title: 'Task Reminder',
          body: 'Dear ${Globals.user},\nYou have got a task named: \'$name\', scheduled for $startTime.\nMake sure you complete it on time\nKeep Grinding!👍',
          scheduledTime: scheduledTime,
        ).then((_){
          debugPrint('$scheduledTime');
        }).onError((error, stackTrace){
          debugPrint('$error');
        });
      }

      if (Globals.isPremium && repetitionDays > 1){
        for (var i = 1; i < repetitionDays; i++){
          String cDate = DateFormat('yyyy-MM-dd').format(date.add(Duration(days: i)));
          if (Globals.AllTasks.containsKey(cDate)){
            final List<dynamic> tasks = Globals.AllTasks[cDate];
            tasks.add(task);
            tasks.sort((a, b) =>
                parseTime(a['startTime']).compareTo(parseTime(b['startTime'])));
            Globals.AllTasks.update(cDate, (value) => tasks);
          }else{
            Globals.AllTasks[cDate] = [task];
          }
          debugPrint('${Globals.AllTasks[cDate]}');
        }
      }

      final jsonMap = jsonEncode(Globals.AllTasks);
      await Globals.prefs.write(key: 'tasks', value: jsonMap);
      return 0;
    }catch (e){
      if(kDebugMode) print('Exception : $e');
      return 100;
    }
  }

  static Future<void> addTasks(BuildContext context) async{
    final pageController = PageController(keepPage: true);
    final GlobalKey<ScaffoldState> Skey = GlobalKey<ScaffoldState>();
    int currentPage = 0;

    TextEditingController Tcontroller = TextEditingController();
    TextEditingController Dcontroller = TextEditingController();
    TextEditingController DUcontroller = TextEditingController(text: '0 min.');

    List<PageStorageKey> pageKeys = [
      const PageStorageKey('FirstPage'),
      const PageStorageKey('SecondPage'),
      const PageStorageKey('ThirdPage'),
    ];

    List<Widget> Pages = [
      PageStorage(key: pageKeys[0],bucket: PageStorageBucket(),child: SingleChildScrollView(child: FirstPage(Tcontroller: Tcontroller, Dcontroller: Dcontroller),),),
      PageStorage(key: pageKeys[1],bucket: PageStorageBucket(), child: SingleChildScrollView(child: SecondPage(DUcontroller: DUcontroller,Skey: Skey,)),),
      PageStorage(key: pageKeys[2],bucket: PageStorageBucket(), child: const SingleChildScrollView(child: ThirdPage(),),),
    ];

    void goToPage(int pageIndex) {
      pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    await precacheImage(const AssetImage('assets/cardBack.png'), context);
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Scaffold(
                key: Skey,
                resizeToAvoidBottomInset: false,
                body: Container(
                    decoration: BoxDecoration(
                        color: AppTheme.colors.friendlyWhite,
                        image: const DecorationImage(image: AssetImage('assets/cardBack.png'), fit: BoxFit.cover, filterQuality: FilterQuality.medium, opacity: 0.3)
                    ),
                    child: Padding( padding: const EdgeInsets.all(16.0), child:Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  IconButton(onPressed: (){
                                    if (currentPage == 0){
                                      return;
                                    }
                                    goToPage(currentPage - 1);
                                    setState((){
                                      currentPage = currentPage - 1;
                                    });
                                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded,size: 25,), color: currentPage == 0? AppTheme.colors.onsetBlue.withOpacity(0.3) : AppTheme.colors.onsetBlue, ),
                                  Expanded(child: Text('Create A New Task',textAlign: TextAlign.center, style: TextStyle(color: AppTheme.colors.friendlyBlack, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: Globals.sysFont),),),
                                  currentPage == Pages.length - 1? GestureDetector(
                                    onTap: (){
                                      if (Globals.isPremium){
                                        createNewTask(Tcontroller.text, Dcontroller.text, SecondPageState.startTime, SecondPageState.duuration, FirstPageState.currentIcon, FirstPageState.currentColor, ThirdPageState.selectedDate, reminder: SecondPageState.reminder, repetition: ThirdPageState.selected).then((result){
                                          if (result == 0) {
                                            FirstPageState.currentColor = null;
                                            FirstPageState.currentIcon = null;
                                            SecondPageState.duuration = const Duration(minutes: 0);
                                            SecondPageState.startTime = const Duration();
                                            ThirdPageState.selectedDate = DateTime.now();
                                            SecondPageState.reminder = false;
                                            ThirdPageState.selected = 1;
                                            Navigator.of(context).pop();
                                            GlobalVar.globalVar.showToast('New Task Added');
                                          }
                                        });
                                      }else{
                                        createNewTask(Tcontroller.text, Dcontroller.text, SecondPageState.startTime, SecondPageState.duuration, FirstPageState.currentIcon, FirstPageState.currentColor, ThirdPageState.selectedDate).then((result){
                                          if (result == 0) {
                                            FirstPageState.currentColor = null;
                                            FirstPageState.currentIcon = null;
                                            SecondPageState.duuration = const Duration(minutes: 0);
                                            SecondPageState.startTime = const Duration();
                                            SecondPageState.reminder = false;
                                            ThirdPageState.selectedDate = DateTime.now();
                                            ThirdPageState.selected = 1;
                                            Navigator.of(context).pop();
                                            GlobalVar.globalVar.showToast('New Task Added');
                                          }
                                        });
                                      }
                                    },
                                    child: Text('Done', style: TextStyle(color: AppTheme.colors.onsetBlue, fontSize: 15.5, fontWeight: FontWeight.bold,  fontFamily: Globals.sysFont),),
                                  ): IconButton(onPressed: (){
                                    goToPage(currentPage + 1);
                                    setState((){
                                      currentPage = currentPage + 1;
                                    });
                                  }, icon: const Icon(Icons.arrow_forward_ios_rounded,size: 25,), color: AppTheme.colors.onsetBlue, ),
                                ]),
                            const SizedBox(height: 10,),
                            Expanded(child:Scaffold(backgroundColor: Colors.transparent, resizeToAvoidBottomInset: true, body: PageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: Pages,
                            ),)),
                          ],),
                        Positioned(
                            bottom: 0,
                            child: Column(
                                children:[
                                  SmoothPageIndicator(controller: pageController, count: Pages.length, effect: ScrollingDotsEffect(
                                    activeDotColor: AppTheme.colors.onsetBlue,
                                    activeDotScale: 1.5,
                                    dotColor: AppTheme.colors.blissCream,
                                    spacing: 10.0
                                  ),),
                                  const SizedBox(height: 20,),
                                  ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyBlack)),
                              onPressed: () {
                                Tcontroller.clear();
                                Dcontroller.clear();
                                DUcontroller.clear();
                                FirstPageState.currentColor = null;
                                FirstPageState.currentIcon = null;
                                SecondPageState.duuration = const Duration(minutes: 0);
                                SecondPageState.startTime = const Duration();
                                ThirdPageState.selectedDate = DateTime.now();
                                ThirdPageState.selected = 1;
                                Navigator.of(context).pop();
                              }, child: Icon(CupertinoIcons.multiply, color: AppTheme.colors.friendlyWhite,),
                            ),
                                ])
                        ,)
                      ],
                    ),)
                ).animate(
                    effects: [
                      flutter_animate.SlideEffect(
                        duration: 250.ms,
                        curve: Curves.linear,
                        begin: Offset.fromDirection(4.7),
                      )
                    ]));
          }
      );
    });
  }
}




