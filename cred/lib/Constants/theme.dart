import 'package:cred/Constants/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

TextStyle listTitleDefaultTextStyle = TextStyle(
    color: Colors.white70, fontSize: 13.0, fontWeight: FontWeight.w600);
TextStyle listTitleSelectedTextStyle =
    TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600);

Color primary = Color(0xFF121212);
Color backColor = Color(0xff202427);
Color dividerColor = Color(0xff152453);
Color textColor = Color(0xffeff2fd);

// List<Color> commonGradient = <Color>[Color(0xff21d6d4), Color(0xff0aa9d7)];
// List<Color> backGradient = <Color>[Color(0xff21d6d4), Color(0xff0aa9d7)];
//12151e

final animatedloader = Center(
  child: Container(
    width: SizeConfig.screenHeight / 8,
    height: SizeConfig.screenHeight / 8,
    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
            SizeConfig.screenHeight / 16),
        border: Border.all(
            color: Colors.grey.shade800,
            width: 2.0)
      // image: DecorationImage(
      //   image: AssetImage("Images/logo.png"),
      // ),
    ),
    child: Image.asset(
      "gifs/loadTrans.gif",
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      height: 100,
      width: 50,
      fit: BoxFit.cover,
    ),
  ),
);