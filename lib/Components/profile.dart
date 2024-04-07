import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../GLOBALS.dart';
import '../db/database.dart';
import '../pages/streaks.dart';
import 'AppTheme.dart';
import 'CustomAppBar.dart';
import 'CustomBox.dart';

class ProfileView{

  static Future<void> addFriend(String Fname) async{
    final Fuser = await DataBase.userCollection?.child(Fname).get();
    if (Fuser!.hasChild('pending_list')){
      List PendingList = Fuser.child('pending_list').value as List;
      if (PendingList.contains(Globals.user)){
        GlobalVar.globalVar.showToast('A request has already been sent.');
        return;
      }
      PendingList.add(Globals.user);
      await Fuser.ref.update({
        'pending_list' : PendingList,
      });
    }else{
      await Fuser.ref.update({
        'pending_list' : [Globals.user],
      });
    }
  }

  static Future<void> removeFriend(String Fname) async {
    final Fuser = await DataBase.userCollection?.child(Fname).get();
    final user = await DataBase.userCollection?.child(Globals.user).get();
    List UFriendList = [];
    List FFriendList = [];
    UFriendList.addAll(user
        ?.child('friend_list')
        .value as List);
    FFriendList.addAll(Fuser
        ?.child('friend_list')
        .value as List);
    UFriendList.remove(Fname);
    FFriendList.remove(Globals.user);
    await user?.ref.update({
      'friend_list': UFriendList,
    });
    await Fuser?.ref.update({
      'friend_list': FFriendList,
    });
    int UFriendCount = user
        ?.child('friendCount')
        .value as int;
    int FFriendCount = Fuser
        ?.child('friendCount')
        .value as int;
    await user?.ref.update({
      'friendCount': UFriendCount - 1,
    });
    await Fuser?.ref.update({
      'friendCount': FFriendCount - 1,
    });
  }


  static Future<void> openProfile(BuildContext context, UserI user, int friendCount) async{
    bool loading = false;
    bool friended = false;
    bool isProfilepic = false;
    String profilepicurl = '';

    Future<void> getPic() async{
      Reference? reference = DataBase.userPicsStorage?.child(user.name);
      try {
        if (reference == null) {
          isProfilepic = false;
        } else {
          isProfilepic = true;
          profilepicurl = await reference.getDownloadURL();
        }
      } catch (e){
        if(kDebugMode) print('Error: $e');
        isProfilepic = false;
      }
    }

    Future<void> isFriend() async{
      final userRef = await DataBase.userCollection?.child(Globals.user).get();
      if (userRef!.hasChild('friend_list')) {
        List FriendList = userRef.child('friend_list').value as List;
        if (FriendList.contains(user.name)){
            friended = true;
          return;
        }
      }
        friended = false;
    }

    try{
      await isFriend();
      await getPic();
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
                          border: Border.all(color: AppTheme.colors.blissCream, width: 2.0),
                          color: isProfilepic? AppTheme.colors.friendlyWhite : AppTheme.colors.onsetBlue,
                          shape: BoxShape.circle,
                          boxShadow: const [BoxShadow(
                            color: Colors.transparent,
                            offset: Offset(0, 0),
                            blurRadius: 30.0,
                          ),
                          ]
                      ),
                      child: isProfilepic? ClipOval(
                        child: Image.network(profilepicurl, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? event){
                          if (event == null){
                            return child;
                          }else {
                            return SpinKitThreeBounce(
                              color: AppTheme.colors.onsetBlue,
                            );
                          }
                        },),
                      ) : Center(
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
                              user.name == Globals.user ? const SizedBox.shrink() : loading==true? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) : ElevatedButton(onPressed: (){
                                setState((){
                                  loading = true;
                                });
                                if (friended){
                                  removeFriend(user.name).then((_){
                                    setState((){
                                      friended = false;
                                      loading = false;
                                    });
                                  });
                                }else {
                                  addFriend(user.name).then((_) {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }
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
                                        Icon(friended? CupertinoIcons.xmark : CupertinoIcons.person_add_solid, color: AppTheme.colors.friendlyWhite, size: 10,),
                                        const SizedBox(width: 10.0,),
                                        Text(friended? 'Unfriend' : 'Add Friend', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 9, fontWeight: FontWeight.w700),),
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
          ).animate(effects: [
            FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
            ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
          ]);
        });
      });
    } catch (e){
      if(kDebugMode) print('Error: $e');
    }
  }
}