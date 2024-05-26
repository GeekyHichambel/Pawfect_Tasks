import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../GLOBALS.dart';
import 'AppTheme.dart';

class UpdatePopup{
  static bool loading = false;

  static Future<void> show(BuildContext context, String url, String accessToken) async{

    showDialog(context: context, builder: (context,){
      return StatefulBuilder(builder: (context, StateSetter setState){
        return Center(
            child: AlertDialog(
                elevation: 0.0,
                alignment: Alignment.center,
                contentPadding: const EdgeInsets.all(20.0),
                backgroundColor: AppTheme.colors.friendlyBlack,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('App has a new update!', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite), textAlign: TextAlign.center,),
                      const SizedBox(height: 40,),
                      Text('Do you want to update now?', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite), textAlign: TextAlign.center,),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :
                          ElevatedButton(onPressed: () async{
                            setState((){
                              loading = true;
                            });
                            await downloadApp(url, context, setState, accessToken);
                          }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                              child: const Text('Yes', style: TextStyle(color: Colors.green),)),
                          ElevatedButton(onPressed: (){
                            setState((){
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                              child: const Text('Not Now', style: TextStyle(color: Colors.red),))
                        ],
                      )
                    ])).animate(effects: [
              FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
              ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
            ])
        );
      });
    });
  }

  static Future<void> downloadApp(String url, BuildContext context, StateSetter setState, String accessToken) async{
    try {
      var dir = await getDownloadsDirectory();
      String savePath = '${dir?.path}/downloaded_apk.apk';
      print(url);

      var response = await http.get(Uri.parse(url), headers: {
        'Authorization' : 'token $accessToken',
        'Accept' : 'application/octet-stream',
      });

      print('${response.statusCode}');

      if (response.statusCode == 200){
        print(savePath);
        var file = await File(savePath).writeAsBytes(response.bodyBytes);
        await OpenFile.open(file.path);
        GlobalVar.globalVar.showToast('Download Completed');
      }

      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        loading = false;
      });
      debugPrint(url);
      GlobalVar.globalVar.showToast('Download Failed');
    }
  }
}