import 'package:flutter/material.dart';


class MyAnimation{

  Widget myClass;
  MyAnimation({ required this.myClass});

  Route createRoute (){
    return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation)=> myClass,
        transitionsBuilder: (context, animation,secondaryAnimation,child){
          const begin = 0.0;
          const end  = 1.0;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final fadeAnimation = animation.drive(tween);

          return FadeTransition(opacity: fadeAnimation,child: child,);
        }
    );
  }

  void navigation(BuildContext context){
    Navigator.of(context).push(createRoute());
  }

}


