import 'package:cred/Constants/size_config.dart';
import 'package:flutter/material.dart';

Color primary = Color(0xFF121212);
Color backColor = Color(0xff202427);
Color dividerColor = Color(0xff152453);
Color textColor = Color(0xffeff2fd);

final animatedloader = Center(
  child: Container(
    width: SizeConfig.screenHeight / 8,
    height: SizeConfig.screenHeight / 8,
    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.screenHeight / 16),
        border: Border.all(color: Colors.grey.shade800, width: 2.0)),
    child: Image.asset(
      "gifs/loadTrans.gif",
      height: 100,
      width: 50,
      fit: BoxFit.cover,
    ),
  ),
);

// List<Color> commonGradient = <Color>[Color(0xff21d6d4), Color(0xff0aa9d7)];
// List<Color> backGradient = <Color>[Color(0xff21d6d4), Color(0xff0aa9d7)];
//12151e
