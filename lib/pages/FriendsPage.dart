import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/profile.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:PawfectTasks/pages/streaks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/CustomBox.dart';
import '../Components/CustomTextField.dart';
import '../Components/NotLoggedIn.dart';
import '../GLOBALS.dart';

class FriendPage extends StatefulWidget{
  const FriendPage({Key? key}) : super(key: key);
  @override
  FriendPageState createState() => FriendPageState();
}
class FriendPageState extends State<FriendPage>{
  bool isfNfocus = false;
  late TextEditingController fNameC = TextEditingController();
  final FocusNode fNfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setupListener();
    fNfocusNode.addListener(() {
      setState(() {
        if (fNfocusNode.hasFocus) {
          isfNfocus = true;
        } else {
          isfNfocus = false;
        }
      });
    });
  }

  @override
  void dispose(){
    fNameC.dispose();
    super.dispose();
  }

  void setupListener(){
    DataBase.userCollection?.child(Globals.user).child('pending_list').onValue.listen((event) async{
      if (event.snapshot.value != null) {
        if (mounted) {
          setState(() {
            getRequests();
          });
        }
      }
    },onError: (e){
      if(kDebugMode) print('Error in DB: $e');
    });
    DataBase.userCollection?.child(Globals.user).child('pending_list').onChildRemoved.listen((event) async{
      if (event.snapshot.value != null){
        if (mounted){
          setState(() {
            getRequests();
          });
        }
      }
    });
  }

  Future<void> searchUser(BuildContext context,String Fname) async{
    try{
      if (Fname.isEmpty) {
        GlobalVar.globalVar.showToast('Field Can\'t be left empty.');
        throw Exception('Field Can\'t be left empty.');
      }
      final user = await DataBase.streakCollection?.child(Fname).get();
      if (user == null || !user.exists){
        GlobalVar.globalVar.showToast('Username is incorrect');
        throw Exception('Username is incorrect');
      }
      final userInfo = await DataBase.userCollection?.child(Fname).get();
      int xp = user.child('xp').value as int;
      int streak = user.child('streak').value as int;
      int friendsCount = userInfo?.child('friendCount').value as int;
      String league = user.child('league').value.toString();
      UserI userI = UserI(Fname, xp, streak, league);
      ProfileView.openProfile(context, userI, friendsCount);
    }catch (e){
      if (kDebugMode) print('Error: $e');
    }
}



  Future<List> getRequests() async{
    try{
      final user = await DataBase.userCollection?.child(Globals.user).get();
      if (user!.child('pending_list').exists) {
        List requests = user
            .child('pending_list')
            .value as List;
        return requests;
      }else{
        return [];
      }
    } catch (e){
      if(kDebugMode) print('Error: $e');
      return [];
    }
  }

  Future<void> acceptRequest(String Fname) async{
    try{
      final user = await DataBase.userCollection?.child(Globals.user).get();
      final Fuser = await DataBase.userCollection?.child(Fname).get();
      if (user!.hasChild('friend_list')){
        List FriendList = [];
        FriendList.addAll(user.child('friend_list').value as List);
        FriendList.add(Fname);
        await user.ref.update({
          'friend_list' : FriendList,
        });
      }else{
        await user.ref.update({
          'friend_list' : [Fname],
        });
      }
      if (Fuser!.hasChild('friend_list')){
        List FriendList = [];
        FriendList.addAll(Fuser.child('friend_list').value as List);
        FriendList.add(Globals.user);
        await Fuser.ref.update({
          'friend_list' : FriendList,
        });
      }else{
        await Fuser.ref.update({
          'friend_list' : [Globals.user],
        });
      }
      int UFriendCount = user.child('friendCount').value as int;
      int FFriendCount = Fuser.child('friendCount').value as int;
      await user.ref.update({
        'friendCount' : UFriendCount + 1,
      });
      await Fuser.ref.update({
        'friendCount' : FFriendCount + 1,
      });
      rejectRequest(Fname);
      if (Fuser.hasChild('pending_list')){
        List PendingList = [];
        PendingList.addAll(Fuser.child('pending_list').value as List);
        if (PendingList.contains(Globals.user)){
          PendingList.remove(Globals.user);
          await Fuser.ref.update({
            'pending_list' : PendingList,
          });
        }
      }
    }catch (e){
      if (kDebugMode) print('Error: $e');
    }
  }

  Future<void> rejectRequest(String Fname) async{
    final user = await DataBase.userCollection?.child(Globals.user).get();
    List PendingList = [];
    PendingList.addAll(user?.child('pending_list').value as List);
    PendingList.remove(Fname);
    await user?.ref.update({
      'pending_list' : PendingList,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [
                Padding(padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), child: Align(
                  alignment: Alignment.centerLeft,
                  child: FadeInAnimation(delay: 1.0,child:Row(
                    children: [
                      Text('Add a Friend',style: TextStyle(
                        fontFamily: Globals.sysFont,
                        color: AppTheme.colors.friendlyBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),),
                      const SizedBox(width: 8.0,),
                      Icon(Icons.person_search_rounded, color: AppTheme.colors.friendlyBlack,size: 32,),
                    ],
                  )),
                ),),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
                  child: FadeInAnimation(delay: 1.25,
                    child: CustomTextField(
                      inputType: TextInputType.name,
                      fontSize: 16.0,
                      labelText: !isfNfocus? (fNameC.text.isNotEmpty? '' : 'Your Friend\'s Name') : (''),
                      controller: fNameC,
                      focusNode: fNfocusNode,
                      labelColor: AppTheme.colors.onsetBlue,
                      bgColor: AppTheme.colors.friendlyWhite,
                      cursorColor: Colors.grey,
                      textColor: AppTheme.colors.onsetBlue,
                      suffixIcon: IconButton(
                        icon: const Icon(CupertinoIcons.search,), onPressed: () {
                          searchUser(context, fNameC.text);
                      },
                        color: AppTheme.colors.onsetBlue,
                      ),
                      borderColor: AppTheme.colors.onsetBlue, obscureText: false,
                    ),),),
                const SizedBox(height: 30,),
                        Padding(padding: const EdgeInsets.only(left: 36.0, right: 36.0),child:Align(
                        alignment: Alignment.centerLeft,
                        child: FadeInAnimation(delay: 1.5,child:Text('Pending Requests',style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: AppTheme.colors.friendlyBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),),),),),
                        const SizedBox(height: 20,),
                        Expanded(
                            child: Padding(padding: const EdgeInsets.only(bottom: 36.0, left: 36.0, right: 36.0),
                                child: FadeInAnimation(delay: 1.75,child: CustomBox(
                                  color: Colors.transparent,
                                  shadow: Colors.transparent,
                                  border: Border(
                                      top: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                      left: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                      right: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                      bottom: BorderSide(color: AppTheme.colors.blissCream, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                                  child: FutureBuilder<List>(
                                    future: getRequests(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                                        return Center(
                                            child: SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,)
                                        );
                                      }else if (!snapshot.hasData || snapshot.data!.isEmpty){
                                        return  Center(
                                          child: Text('No requests to display',
                                            style: TextStyle(
                                                color: AppTheme.colors.blissCream,
                                                fontWeight: FontWeight.w700),),
                                        );
                                      }else{
                                        bool loading = false;
                                       return Padding(
                                           padding: const EdgeInsets.all(16.0),
                                           child: loading == true? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) : ListView.builder(
                                               itemCount: snapshot.data!.length,
                                               physics: const RangeMaintainingScrollPhysics(),
                                               itemBuilder: (context, index){
                                                 final user = snapshot.data![index];
                                                 return Padding(
                                                   padding: const EdgeInsets.only(bottom: 5.0),
                                                   child: GestureDetector(onTap: () async{
                                                     final userSInfo = await DataBase.streakCollection?.child(user).get();
                                                     final userInfo = await DataBase.userCollection?.child(user).get();
                                                     int xp = userSInfo?.child('xp').value as int;
                                                     int streak = userSInfo?.child('streak').value as int;
                                                     int friendsCount = userInfo?.child('friendCount').value as int;
                                                     String league = userSInfo!.child('league').value.toString();
                                                     UserI userI = UserI(user, xp, streak, league);
                                                     ProfileView.openProfile(context, userI, friendsCount);
                                                   },child: ListTile(
                                                     tileColor: AppTheme.colors.friendlyBlack,
                                                     shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.colors.blissCream),borderRadius: const BorderRadius.all(Radius.circular(16.0))),
                                                     title: Text(user.toString().length > 8 ? '${user.toString().substring(0,5)}...': user.toString(), style: TextStyle(color: AppTheme.colors.friendlyWhite, fontWeight: FontWeight.w700,fontFamily: Globals.sysFont, fontSize: 16)),
                                                     leading: Text('${index+1}', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 16),),
                                                     trailing: SizedBox(
                                                       width: 80, height: 30,
                                                       child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.end,
                                                       mainAxisSize: MainAxisSize.min,
                                                       children: [
                                                         Expanded(child: ElevatedButton(
                                                             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite),
                                                                 padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero)),
                                                             onPressed: (){
                                                               setState(() {
                                                                 loading = true;
                                                               });
                                                                acceptRequest(user.toString()).then((_){
                                                                  setState(() {
                                                                    loading = false;
                                                                  });
                                                                });
                                                             },
                                                             child: const Icon(CupertinoIcons.check_mark, color: Colors.green, size: 12,)),),
                                                         const SizedBox(width: 5.0,),
                                                         Expanded(child: ElevatedButton(
                                                             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite),
                                                               padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero)
                                                             ),
                                                             onPressed: (){
                                                                setState(() {
                                                                  loading = true;
                                                                });
                                                                rejectRequest(user.toString()).then((_){
                                                                  setState(() {
                                                                    loading = false;
                                                                  });
                                                                });
                                                             },
                                                             child: const Icon(CupertinoIcons.multiply, color: Colors.red, size: 12,)),),
                                                       ],
                                                     ),
                                                   ),),),
                                                 );
                                           }),
                                       );
                                      }
                                    }
                                ),),),
                            )
                        ),
          ] : [
            const NotLoggedInWidget(),
          ],
      ),
    );
  }

}