import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'AppTheme.dart';

class WebOpenerIcon extends StatelessWidget{
  final String imagePath;
  final String link;

  const WebOpenerIcon({
    super.key,
    required this.imagePath,
    required this.link,
});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () async{
        if (!await launchUrlString(link)){
          throw Exception('Can\'t launch the link');
        }
      },
      child: Image.asset(imagePath, color: AppTheme.colors.onsetBlue,height: 25, width: 25,),
    );
  }
}