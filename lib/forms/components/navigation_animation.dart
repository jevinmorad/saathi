import 'package:flutter/cupertino.dart';

void navigateWithAnimation(
    {required BuildContext context, required Widget page}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn),);
        var offSetAnimation = animation.drive(tween);

        return SlideTransition(position: offSetAnimation, child: child);
      },
    ),
  );
}
