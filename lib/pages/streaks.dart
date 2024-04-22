import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  int USlot = 0;
  int UXP = 0;
  int UStreak = 0;
  int Selected = 1;
  List<String> leagues = ['Rookie', 'Junior', 'Intermediate', 'Senior', 'Elite', 'Premier'];

  Future<void> getData() async{
    final user = await DataBase.streakCollection?.child(Globals.user).get();
    final league = user?.child('league').value.toString();
    final slot = user?.child('slot').value as int;
    final xp = user?.child('xp').value as int;
    final streak = user?.child('streak').value as int;
    setState(() {
      Uleague = league!;
      USlot = slot;
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
     if (Selected == 1) {
       final user = await DataBase.streakCollection?.child(Globals.user).get();
       final league = user
           ?.child('league')
           .value
           .toString();
       final leaderboard_ref = await DataBase.leaderboardCollection?.child(
           league!).child('Slot$USlot').limitToFirst(25).get();
       if (leaderboard_ref != null && leaderboard_ref.exists) {
         for (var element in leaderboard_ref.children) {
           String name = element.key.toString();
           int xp = element
               .child('xp')
               .value as int;
           int streak = element
               .child('streak')
               .value as int;
           leaderboard.add(UserI(name, xp, streak, league!));
         }
       }
       bool inLeaderboard = leaderboard.any((user) => user.name == Globals.user);
       if (!inLeaderboard){
         if (leaderboard.length >= 25) leaderboard.removeLast();
         leaderboard.add(UserI(Globals.user, user?.child('xp').value as int, user?.child('streak').value as int, league!, ));
       }
       int xpComparator(UserI a, UserI b) => b.xp.compareTo(a.xp);
       leaderboard.sort(xpComparator);
     } else if (Selected == 2){
       final user = await DataBase.userCollection?.child(Globals.user).get();
       final user_ref = await DataBase.streakCollection?.child(Globals.user).get();
       List friend_list = [];
       friend_list.addAll(user?.child('friend_list').value as List);
       if (friend_list.isEmpty) throw Exception('No friends to display');
       int xpComparator(UserI a, UserI b) => b.xp.compareTo(a.xp);
       for (var friend in friend_list){
         final friend_ref = await DataBase.streakCollection?.child(friend).get();
         String name = friend;
         int xp = friend_ref?.child('xp').value as int;
         int streak = friend_ref?.child('streak').value as int;
         String? league = friend_ref?.child('league').value.toString();
         leaderboard.add(UserI(name, xp, streak, league!));
       }
       leaderboard.add(UserI(Globals.user, user_ref?.child('xp').value as int, user_ref?.child('streak').value as int, user_ref!.child('league').value.toString()));
       leaderboard.sort(xpComparator);
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
    return SafeArea(child: !pageLoaded? const Scaffold() : Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 20,
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
            Container(color: AppTheme.colors.friendlyWhite, margin: const EdgeInsets.only(bottom: 10.0),child: Align(alignment: Alignment.centerRight,
                child: Padding(padding: const EdgeInsets.only(right: 16.0), child: Row(
                    mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(16.0), child: ElevatedButton(
                      style: ButtonStyle(elevation: const MaterialStatePropertyAll<double>(2.5),backgroundColor: MaterialStatePropertyAll<Color>(Selected == 1? AppTheme.colors.onsetBlue : AppTheme.colors.friendlyWhite),),
                      onPressed: (){
                        setState((){
                          Selected = 1;
                        });
                      },
                      child: Icon(CupertinoIcons.globe, color: Selected == 1? AppTheme.colors.friendlyWhite : AppTheme.colors.onsetBlue, size: 16,)),),
                  const SizedBox(width: 5.0,),
                  ClipRRect(borderRadius: BorderRadius.circular(16.0), child: ElevatedButton(
                      style: ButtonStyle(elevation: const MaterialStatePropertyAll<double>(2.5),backgroundColor: MaterialStatePropertyAll<Color>(Selected == 2? AppTheme.colors.onsetBlue : AppTheme.colors.friendlyWhite)),
                      onPressed: (){
                        setState((){
                          Selected = 2;
                        });
                      },
                      child: Icon(CupertinoIcons.person_2_fill, color: Selected == 2? AppTheme.colors.friendlyWhite : AppTheme.colors.onsetBlue, size: 16,)),),
                ],
              ),),),
            ),
            Expanded(child: FutureBuilder<List<UserI>>(
                  future: updateLeaderboard(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                      return Center(
                          child: SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,)
                      );
                    }
                    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text(
                                Selected == 1? 'Leaderboard is Empty' : 'No Friends to Display',
                                style: TextStyle(
                                  color: AppTheme.colors.friendlyBlack,
                                  fontFamily: Globals.sysFont,
                                  fontSize: 18,
                                )
                            ),
                      );
                    } else{
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0,),
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index){
                              UserI user = snapshot.data![index];
                              return Padding(padding: const EdgeInsets.only(bottom: 5.0),
                                  child: GestureDetector(
                                    onTap: () async{
                                      final ref = await DataBase.userCollection?.child(user.name).get();
                                      final int friendCount = ref?.child('friendCount').value as int;
                                      ProfileView.openProfile(context, user, friendCount);
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
    ));
  }

}