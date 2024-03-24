import 'dart:io';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/Components/CustomElevatedButton.dart';
import 'package:PawfectTasks/Components/CustomTextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/Animations.dart';
import '../../GLOBALS.dart';
import '../../db/database.dart';

class Uinfo extends StatefulWidget{
  const Uinfo({Key? key}) : super(key: key);
  @override
  UinfoState createState() => UinfoState();
}

class UinfoState extends State<Uinfo>{
  String mail = '';
  bool ChangeLoading = false;
  bool Mread = true;
  File? profile_pic;
  late TextEditingController mController = TextEditingController();
  final FocusNode MfocusNode = FocusNode();

  Future<void> getMail() async{
    final user_ref = await DataBase.userCollection?.child(Globals.user).get();
    if (!user_ref!.hasChild('mail')) {
      return;
    }
    String mailAdd = user_ref.child('mail').value.toString();
    setState(() {
      mail = mailAdd;
      mController.text = mail;
    });
  }

  Future<void> getImage() async{
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null){
      setState(() {
        profile_pic = File(pickedImage.path);
      });
    }
  }

  Future<void> saveChanges() async{
    if (profile_pic != null){
      try {
        Reference? reference = DataBase.userPicsStorage?.child(Globals.user);
        await reference?.putFile(
            profile_pic!);
        Globals.profilepicurl = await reference!.getDownloadURL();
      }catch (e){
        if(kDebugMode) print('Exception: $e');
      }
    }
    if (mController.text != mail){
      try{

      }catch (e){
        if(kDebugMode) print('Exception: $e');
      }
    }
    GlobalVar.globalVar.showToast('Changes Saved');
  }

  @override
  void initState(){
    super.initState();
    getMail();
    MfocusNode.addListener(() {
      if (!MfocusNode.hasFocus){
        setState(() {
          Mread = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: CustomAppBar()
            ),
            FadeInAnimation(delay: 1, child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Account',
                    style: TextStyle(
                      color: AppTheme.colors.friendlyBlack,
                      fontWeight: FontWeight.bold,
                      fontFamily: Globals.sysFont,
                      fontSize: 32.0,
                    ),),
                  const SizedBox(width: 20.0,),
                  Image.asset('assets/user_icon.png', width: 45, height: 45,),
                ]
            ),),Expanded(child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  bottom: 0,
                    child: ChangeLoading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,): CustomElevatedButton(onPress: (){
                      setState(() {
                        ChangeLoading = true;
                      });
                      saveChanges().then((_){
                        setState(() {
                          ChangeLoading = false;
                        });
                      });
                },
                  child: Center(child: Text('Save', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 12, fontWeight: FontWeight.w700),),),
                )),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                  physics: const RangeMaintainingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInAnimation(delay: 1, child: Stack(children: [Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.friendlyBlack, width: 2.0),
                              color: Globals.isprofilepic? AppTheme.colors.friendlyWhite : AppTheme.colors.onsetBlue,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(
                                color: Colors.transparent,
                                offset: Offset(0, 0),
                                blurRadius: 30.0,
                              ),
                              ]
                          ),
                          child: profile_pic==null? Globals.isprofilepic? ClipOval(
                            child: Image.network(Globals.profilepicurl, fit: BoxFit.cover,loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? event){
                              if (event == null){
                                return child;
                              }else {
                                return SpinKitThreeBounce(
                                  color: AppTheme.colors.onsetBlue,
                                );
                              }
                            },),
                          ) : Center(
                            child: Text(Globals.user[0],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: Globals.sysFont,
                                fontSize: 45,
                                color: AppTheme.colors.friendlyWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ) : CircleAvatar(
                            backgroundImage: FileImage(profile_pic!),
                          ),
                        ),
                      ),
                        Positioned(
                            bottom: 0,
                            right: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                getImage();
                              },
                              style: ButtonStyle(
                                shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(side: BorderSide())),
                                backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyBlack),
                                padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
                              ),
                              child: Icon(CupertinoIcons.pencil, color: AppTheme.colors.friendlyWhite,size: 16,),))
                      ])),
                      const SizedBox(height: 20,),
                      FadeInAnimation(delay: 1.25,
                        child: Text('Username',
                          style: TextStyle(
                            color: AppTheme.colors.friendlyBlack,
                            fontWeight: FontWeight.bold,
                            fontFamily: Globals.sysFont,
                            fontSize: 16.0,
                          ),),),
                      const SizedBox(height: 5.0,),
                      FadeInAnimation(delay: 1.25, child: CustomTextField(
                        cursorColor: AppTheme.colors.blissCream,
                        bgColor: AppTheme.colors.friendlyWhite,
                        textColor: AppTheme.colors.onsetBlue,
                        borderColor: AppTheme.colors.onsetBlue,
                        type: Globals.focused,
                        labelColor: AppTheme.colors.onsetBlue,
                        fontSize: 16.0,
                        controller: TextEditingController(text: Globals.user),
                        readOnly: true,
                        enabled: false,
                        canRequestFocus: false,
                        obscureText: false,
                      ),),
                      const SizedBox(height: 20.0,),
                      FadeInAnimation(delay: 1.25,
                        child: Text('Email',
                          style: TextStyle(
                            color: AppTheme.colors.friendlyBlack,
                            fontWeight: FontWeight.bold,
                            fontFamily: Globals.sysFont,
                            fontSize: 16.0,
                          ),),),
                      const SizedBox(height: 5.0,),
                      FadeInAnimation(delay: 1.25, child: CustomTextField(
                        cursorColor: AppTheme.colors.blissCream,
                        bgColor: AppTheme.colors.friendlyWhite,
                        textColor: AppTheme.colors.onsetBlue,
                        borderColor: AppTheme.colors.onsetBlue,
                        type: Globals.focused,
                        maxLines: 1,
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            Mread = !Mread;
                          });
                          MfocusNode.requestFocus();
                        }, icon: Icon(Mread? Icons.edit_rounded : Icons.close_rounded, color: AppTheme.colors.blissCream,size: 22,),),
                        labelColor: AppTheme.colors.onsetBlue,
                        fontSize: 16.0,
                        focusNode: MfocusNode,
                        controller: mController,
                        readOnly: Mread,
                        canRequestFocus: true,
                        obscureText: false,
                      ),),
                      const SizedBox(height: 20.0,),
                    ],
                  ),
                ),
              ],
            ),),
          ],
        ),
      ),
   );
  }
}