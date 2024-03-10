import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../Components/NotLoggedIn.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';

class Streaks extends StatefulWidget{
  const Streaks({Key? key}) : super(key: key);
  @override
  _StreakState createState() => _StreakState();
}

class UserI{
  final String name;
  final int xp;
  final int streak;
  final String league;
  UserI(this.name, this.xp, this.streak, this.league);
}

class _StreakState extends State<Streaks>{
  bool pageLoaded = false;
  String Uleague = 'Rookie';
  int UXP = 0;
  int UStreak = 0;
  List<String> leagues = ['Rookie', 'Junior', 'Intermediate', 'Senior', 'Elite', 'Premier'];

  Future<void> openProfile(BuildContext context, UserI user, int friendCount) async{
    try{
      await showDialog(context: context, builder: (context){
        return StatefulBuilder(builder: (BuildContext context,StateSetter setState){
          return SizedBox(height: 300,
            child: AlertDialog(
              elevation: 0.0,
              scrollable: true,
              alignment: Alignment.center,
              backgroundColor: AppTheme.colors.friendlyBlack,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16))),
              content: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                children: [
                  const CustomAppBar(),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: AppTheme.colors.onsetBlue,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(0, 0),
                          blurRadius: 30.0,
                        ),
                        ]
                    ),
                    child: Center(
                      child: Text(user.name[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Globals.sysFont,
                          fontSize: 40,
                          color: AppTheme.colors.friendlyWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(user.name, style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite,fontWeight: FontWeight.w700),),
                        const SizedBox(height: 5,),
                        Text('$friendCount Friends', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue),),
                        const SizedBox(height: 5,),
                        user.name == Globals.user? const SizedBox.shrink() : ElevatedButton(onPressed: (){
                                                        
                        },style:const ButtonStyle(
                          padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
                        ),
                          child: CustomBox(
                            height: 50,
                            width: 100,
                            border: Border(
                                top: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                left: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                right: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                bottom: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                            shadow: Colors.transparent,
                            color: AppTheme.colors.onsetBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(CupertinoIcons.person_add_solid, color: AppTheme.colors.friendlyWhite, size: 10,),
                              const SizedBox(width: 10.0,),
                              Text('Add Friend', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 9, fontWeight: FontWeight.w700),),
                            ],),),
                          ),
                        ),
                      ]),),),
                  const SizedBox(height: 20,),
                  Text('Stats', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontWeight: FontWeight.w700),),
                  const SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                    height: 250,
                    child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
                      children: [
                        CustomBox(
                          elevation: 24.0,
                          border: Border(
                              top: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              left: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              right: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              bottom: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside)),
                          shadow: Colors.transparent,
                          color: AppTheme.colors.friendlyBlack,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset('assets/streak_icon.png',),),
                                const SizedBox(width: 5.0,),
                                Expanded(flex: 2,child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${user.streak}', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.pukeOrange,fontWeight: FontWeight.w700, fontSize: 8),),
                                    Text('Day Streak', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.blissCream, fontSize: 8),),
                                  ],
                                )),
                              ],),),
                        ),
                        CustomBox(
                          elevation: 24.0,
                          border: Border(
                              top: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              left: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              right: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              bottom: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside)),
                          shadow: Colors.transparent,
                          color: AppTheme.colors.friendlyBlack,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset('assets/xp_icon.png',),),
                                const SizedBox(width: 5.0,),
                                Expanded(flex: 2,child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${user.xp}', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.pukeOrange,fontWeight: FontWeight.w700, fontSize: 8),),
                                    Text('Total XP', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.blissCream, fontSize: 8),),
                                  ],
                                )),
                              ],),),
                        ),
                        CustomBox(
                          elevation: 24.0,
                          border: Border(
                              top: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              left: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              right: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
                              bottom: BorderSide(color: AppTheme.colors.blissCream, width: 1.0, strokeAlign: BorderSide.strokeAlignInside)),
                          shadow: Colors.transparent,
                          color: AppTheme.colors.friendlyBlack,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset('assets/leagues/${user.league}.png',),),
                                const SizedBox(width: 5.0,),
                                Expanded(flex: 2, child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.league, style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.pukeOrange,fontWeight: FontWeight.w700, fontSize: 8),),
                                    Text('Current League', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.blissCream, fontSize: 8),),
                                  ],
                                )),
                              ],),),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
            ),
          );
        });
      });
    } catch (e){
      if(kDebugMode) print('Error: $e');
    }
  }

  Future<void> getData() async{
    final user = await DataBase.streakCollection?.child(Globals.user).get();
    final league = user?.child('league').value.toString();
    final xp = user?.child('xp').value as int;
    final streak = user?.child('streak').value as int;
    setState(() {
      Uleague = league!;
      UStreak = streak;
      UXP = xp;
    });
    setState(() {
      pageLoaded = true;
    });
}

  String _getLeagueName(int index) {
    return leagues[index];
  }

  Future<List<UserI>> updateLeaderboard() async{
   try{
     List<UserI> leaderboard = [];
     final user = await DataBase.streakCollection?.child(Globals.user).get();
     final league = user?.child('league').value.toString();
     final leaderboard_ref = await DataBase.leaderboardCollection?.child(league!).limitToFirst(25).get();
     if (leaderboard_ref != null && leaderboard_ref.exists){
       for (var element in leaderboard_ref.children) {
         String name = element.key.toString();
         int xp = element.child('xp').value as int;
         int streak = element.child('streak').value as int;
         leaderboard.add(UserI(name, xp, streak, league!));
       }
     }
     return leaderboard;
   } catch(e){
     if (kDebugMode) print('Error fetching leaderboard: $e');
     return [];
   }
  }


  void setUpListener(){
    DataBase.streakCollection?.child(Globals.user).child('league').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          Uleague = user!.child('league').value.toString();
        });
      }
      });
    DataBase.streakCollection?.child(Globals.user).child('xp').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          UXP = user!.child('xp').value as int;
        });
      }
    });
    DataBase.streakCollection?.child(Globals.user).child('streak').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          UStreak = user!.child('streak').value as int;
        });
      }
    });
  }

  @override
  void initState() {
    if (Globals.LoggedIN) {
      getData();
      setUpListener();
    }else{
      setState(() {
        pageLoaded = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !pageLoaded? const Scaffold() : Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 0,
            vertical: 30,
          ),
          child: CustomAppBar(),
        ),
      ),
      body: Column(
          mainAxisAlignment: Globals.LoggedIN? MainAxisAlignment.start : MainAxisAlignment.center,
          children: Globals.LoggedIN
           ? [
            SizedBox(
              height: 80,
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final size = (Uleague == _getLeagueName(index)) ? 80.0 : 60.0;
                    final unlocked = (index <= leagues.indexOf(Uleague));

                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Center(
                        child: unlocked
                            ? Image.asset(
                          'assets/leagues/${_getLeagueName(index)}.png',
                          width: size,
                          height: size,
                        )
                            : Image.asset(
                          'assets/leagues/lock.png',
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: AppTheme.colors.friendlyWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.colors.blissCream,
                    strokeAlign: BorderSide.strokeAlignInside,
                    width: 2.0,
                  ),
                ),
              ),
              child: Column(
                children: [
                  FadeInAnimation(
                    delay: 0.5,
                    child: Text(
                      '$Uleague League',
                      style: TextStyle(
                        color: AppTheme.colors.onsetBlue,
                        fontSize: 28,
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0,),
                  FadeInAnimation(
                    delay: 1.0,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: 'Total XP: ',
                            style: TextStyle(color: AppTheme.colors.friendlyBlack),
                          ),
                          TextSpan(
                            text: '$UXP',
                            style: TextStyle(color: AppTheme.colors.onsetBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  FadeInAnimation(
                    delay: 1.0,
                    child: Text(
                      'Earn more XP to advance to the higher leagues',
                      style: TextStyle(
                        color: AppTheme.colors.blissCream,
                        fontSize: 16,
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Expanded(child: FutureBuilder<List<UserI>>(
                  future: updateLeaderboard(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                      return Center(
                          child: CircularProgressIndicator(color: AppTheme.colors.onsetBlue,)
                      );
                    }
                    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Column(
                          children: [
                            Text(
                                'Leaderboard is Empty',
                                style: TextStyle(
                                  color: AppTheme.colors.friendlyBlack,
                                )
                            ),
                          ]
                      );
                    } else{
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0,),
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            physics: const RangeMaintainingScrollPhysics(),
                            itemBuilder: (context, index){
                              UserI user = snapshot.data![index];
                              return Padding(padding: const EdgeInsets.only(bottom: 5.0),
                                  child: GestureDetector(
                                    onTap: () async{
                                      final ref = await DataBase.userCollection?.child(user.name).get();
                                      final int friendCount = ref?.child('friendCount').value as int;
                                      openProfile(context, user, friendCount);
                                    },
                                    child: ListTile(
                                  tileColor: AppTheme.colors.friendlyBlack,
                                  shape: RoundedRectangleBorder(side: user.name == Globals.user? BorderSide(color: AppTheme.colors.onsetBlue, width: 2.5) : BorderSide(color: AppTheme.colors.blissCream),borderRadius: const BorderRadius.all(Radius.circular(16.0))),
                                  leading: Text('${index+1}', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 18),),
                                  title: Row(
                                      children: [
                                        Text(user.name.length > 8? '${user.name.substring(0,5)}...': user.name, style: TextStyle(color: AppTheme.colors.friendlyWhite, fontWeight: FontWeight.w700,fontFamily: Globals.sysFont, fontSize: 18)),
                                        const SizedBox(width: 16.0,),
                                        Text('${user.streak}', style: TextStyle(color: AppTheme.colors.pukeOrange, fontFamily: Globals.sysFont, fontSize: 18),),
                                        const SizedBox(width: 2.0,),
                                        Image.asset('assets/streak_icon.png', width: 18.0, height: 18.0,),
                                      ]),
                                  trailing: Text('${user.xp} XP', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 18),),
                                  ),));
                            }
                        )
                      );
                    }
                  },
                ),
            ),
          ] : [
            const NotLoggedInWidget(),
          ]
        )
    );
  }

}