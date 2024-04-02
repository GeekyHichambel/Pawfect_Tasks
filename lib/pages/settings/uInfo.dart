import 'dart:io';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/Components/CustomElevatedButton.dart';
import 'package:PawfectTasks/Components/CustomTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/Animations.dart';
import '../../Components/NotLoggedIn.dart';
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
  bool Pread = true;
  File? profile_pic;
  late TextEditingController mController = TextEditingController();
  late TextEditingController pController = TextEditingController(text: '••••••••');
  final FocusNode MfocusNode = FocusNode();
  final FocusNode PfocusNode = FocusNode();

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

  bool isValidMail(String mailAdd){
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(mailAdd);
  }
  
  Future<String> popUpPassword(BuildContext context) async{
    final TextEditingController passC = TextEditingController();
    String password = '';

    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return SizedBox(height: 300,
              child: AlertDialog(
                elevation: 0,
                scrollable: true,
                alignment: Alignment.center,
                contentPadding: const EdgeInsets.all(20.0),
                backgroundColor: AppTheme.colors.friendlyBlack,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Column(
                  children: [
                    Text('Enter your Password!', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite),),
                    const SizedBox(height: 20,),
                    CustomTextField(
                      inputType: TextInputType.text,
                      fontSize: 16.0,
                      controller: passC,
                      labelColor: AppTheme.colors.onsetBlue,
                      bgColor: AppTheme.colors.friendlyWhite,
                      cursorColor: AppTheme.colors.pleasingWhite,
                      textColor: AppTheme.colors.onsetBlue,
                      borderColor: AppTheme.colors.onsetBlue, obscureText: false,
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          setState((){
                            password = passC.text;
                          });
                          Navigator.of(context).pop(password);
                        }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                            child: const Text('Submit', style: TextStyle(color: Colors.green),)),
                      ],
                    )
                  ],
                ),
              ),
            ).animate(effects: [
              FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
              ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
            ]);
          }
      );
    });
    return password;
  }

  Future<void> saveChanges() async{
    int changes = 0;
    if (profile_pic != null){
      try {
        Reference? reference = DataBase.userPicsStorage?.child(Globals.user);
        await reference?.putFile(
            profile_pic!);
        Globals.profilepicurl = await reference!.getDownloadURL();
        changes += 1;
      }catch (e){
        if(kDebugMode) print('Exception: $e');
      }
    }
    if (mController.text != mail){
      try{
        final String newAdd = mController.text;
        if (!isValidMail(newAdd)) { GlobalVar.globalVar.showToast('Invalid Email Address'); return; }
        final user = await DataBase.userCollection?.child(Globals.user).get();
          User? fuser = DataBase.firebaseAuth.currentUser;
          if (fuser != null){
            final String mailAdd = user!.child('mail').value.toString();
            final String mailPass = await popUpPassword(context);
            AuthCredential credential = EmailAuthProvider.credential(email: mailAdd, password: mailPass);
            await fuser.reauthenticateWithCredential(credential);
            await fuser.verifyBeforeUpdateEmail(newAdd);
          }else{
            throw Exception('User null');
          }
        await user.ref.update({
          'mail': newAdd,
        });
          changes += 1;
      }catch (e){
        if(kDebugMode) print('Exception: $e');
      }
    }
    if (changes != 0) {
      GlobalVar.globalVar.showToast('Changes Saved');
    } else{
      GlobalVar.globalVar.showToast('No Changes to Save');
    }
  }

  @override
  void initState(){
    super.initState();
    getMail();
    PfocusNode.addListener(() {
      if(!PfocusNode.hasFocus){
        setState(() {
          Pread = true;
        });
      }
    });
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
   return SafeArea(child: Scaffold(
     resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 0,
            end: 0,
            top: 0,
            bottom: 20,
          ),
          child: CustomAppBar(),
        ),
      ),
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: Globals.LoggedIN? MainAxisAlignment.start : MainAxisAlignment.center,
          children: Globals.LoggedIN? [
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
                Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: true,
                  body: SingleChildScrollView(
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
                          inputType: TextInputType.emailAddress,
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
                        FadeInAnimation(delay: 1.5,
                          child: Text('Password',
                            style: TextStyle(
                              color: AppTheme.colors.friendlyBlack,
                              fontWeight: FontWeight.bold,
                              fontFamily: Globals.sysFont,
                              fontSize: 16.0,
                            ),),),
                        const SizedBox(height: 5.0,),
                        FadeInAnimation(delay: 1.5, child: CustomTextField(
                          cursorColor: AppTheme.colors.blissCream,
                          bgColor: AppTheme.colors.friendlyWhite,
                          textColor: AppTheme.colors.onsetBlue,
                          borderColor: AppTheme.colors.onsetBlue,
                          type: Globals.focused,
                          maxLines: 1,
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              Pread = !Pread;
                            });
                            PfocusNode.requestFocus();
                          }, icon: Icon(Pread? Icons.edit_rounded : Icons.close_rounded, color: AppTheme.colors.blissCream,size: 22,),),
                          labelColor: AppTheme.colors.onsetBlue,
                          fontSize: 16.0,
                          focusNode: PfocusNode,
                          controller: pController,
                          readOnly: Pread,
                          canRequestFocus: true,
                          obscureText: false,
                        ),),
                      ],
                    ),
                  ),),
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
                  ],
                ),),
          ] : [
            const NotLoggedInWidget(),
          ],
        ),
                ),
   ));
  }
}