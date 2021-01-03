import 'package:flutter/material.dart';

class AppBarTExtStyle extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final double size;
  AppBarTExtStyle({this.title, this.gradient, this.size});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (bounds) => gradient
            .createShader(Rect.fromLTWH(0, 5, bounds.width, bounds.height)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: 'Anton',
              fontSize: size,
              color: Color(0xFFd4cdb3)),
        ));
  }
}

// (colors: [
//               Colors.grey,
//               Colors.white,
//               Colors.red[500],
//               Colors.grey
//             ])
