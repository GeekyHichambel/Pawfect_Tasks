import 'package:flutter/material.dart';

@immutable
class animS{
  PageRouteBuilder customRightSlideIn(content) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation,) {
        return content;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutSine;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  const animS();
}