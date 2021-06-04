import 'dart:math';

import 'package:flutter/material.dart';

import 'customClipper.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.height *.5:MediaQuery.of(context).size.height *0.7,
              width: MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.redAccent,Colors.redAccent]
                  )
              ),
            ),
          ),
        )
    );
  }
}