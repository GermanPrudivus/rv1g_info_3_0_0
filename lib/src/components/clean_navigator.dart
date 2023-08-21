import 'package:flutter/material.dart';

void navigateTo(Widget page, BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;
                                          
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    )
  );
}