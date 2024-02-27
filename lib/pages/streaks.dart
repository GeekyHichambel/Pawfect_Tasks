import 'package:PawfectTasks/Components/Animations.dart';
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

class _StreakState extends State<Streaks>{
  bool pageLoaded = false;
  String Uleague = 'Rookie';
  int UXP = 0;
  int UStreak = 0;
  List<String> leagues = ['Rookie', 'Junior', 'Intermediate', 'Senior', 'Elite', 'Premier'];


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

  Future<void> updateLeaderboard() async{
    final user = await DataBase.streakCollection?.child(Globals.user).get();
    final userLeague = user!.child('league').value.toString();
    final leaderboard = await DataBase.leaderboardCollection?.child(userLeague).get();
    if (leaderboard!.children.length < 25){
      if (leaderboard.hasChild(Globals.user)){
        final userXP = user.child('xp').value as int;
        final userStreak = user.child('streak').value as int;
        await leaderboard.ref.child(Globals.user).set({
          'xp' : userXP,
          'streak' : userStreak,
        });
      }else{
        final lastUser = leaderboard.children.last;
        final userXP = user.child('xp').value as int;
        final userStreak = user.child('streak').value as int;
        if (userXP >= (lastUser.child('xp').value as int)){
          await lastUser.ref.remove();
          await leaderboard.ref.child(Globals.user).set({
            'xp' : userXP,
            'streak' : userStreak,
          });
          //TODO: complete this method leaderboard updation
        }
      }
    }
  }

  void setUpListener(){
    DataBase.streakCollection?.child(Globals.user).child('league').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          Uleague = user!.child('league').value.toString();
        });
        //await updateLeaderboard();
      }
      });
    DataBase.streakCollection?.child(Globals.user).child('xp').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          UXP = user!.child('xp').value as int;
        });
        //await updateLeaderboard();
      }
    });
    DataBase.streakCollection?.child(Globals.user).child('streak').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        final user = await DataBase.streakCollection?.child(Globals.user).get();
        setState(() {
          UStreak = user!.child('streak').value as int;
        });
        //await updateLeaderboard();
      }
    });
  }

  @override
  void initState() {
    getData();
    setUpListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !pageLoaded? const Scaffold() : Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 10),
              child: CustomAppBar(),
            ),
           SizedBox(
             height: 80,
             child: Center(
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 physics: const AlwaysScrollableScrollPhysics(),
                 itemCount: 6,
                 itemBuilder: (context, index){
                   final size = (Uleague == _getLeagueName(index))? 80.0 : 60.0;
                   final unlocked = (index <= leagues.indexOf(Uleague));

                   return Padding(padding: const EdgeInsets.only(right: 20.0),
                     child: Center(
                       child: unlocked? Image.asset('assets/leagues/${_getLeagueName(index)}.png',
                         width: size,
                         height: size,
                       ) : Image.asset('assets/leagues/lock.png', width: 50.0, height: 50.0,),
                     )
                   );
                 }
               ),
             ),
           ),
            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.colors.blissCream, strokeAlign: BorderSide.strokeAlignInside, width: 2.0)),
              ),
              child: Column(
                children: [
                  FadeInAnimation(delay: 0.5, child: Text('$Uleague League', style: TextStyle(color: AppTheme.colors.onsetBlue, fontSize: 28, fontFamily: Globals.sysFont, fontWeight: FontWeight.w700))),
                  const SizedBox(height: 5.0,),
                  FadeInAnimation(delay: 1.0, child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(text: 'Total XP: ', style: TextStyle(color: AppTheme.colors.friendlyBlack)),
                        TextSpan(text: '$UXP', style: TextStyle(color: AppTheme.colors.onsetBlue))
                      ]
                    ),
                  ),),
                  const SizedBox(height: 10.0,),
                  FadeInAnimation(delay: 1.0, child: Text('Earn more XP to advance to the higher leagues', style: TextStyle(color: AppTheme.colors.blissCream, fontSize: 16, fontFamily: Globals.sysFont, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}