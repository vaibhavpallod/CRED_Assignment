import 'dart:convert';

import 'package:cred/Constants/API.dart';
import 'package:cred/Constants/size_config.dart';
import 'package:cred/Constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  Animation animation;
  bool isSuccess = false, showGIF = false, isToogleOn = false;
  AnimationController targetController,
      apiResponseController,
      animationController;
  Animation<Offset> TargetAnimation;
  Animation<double> apiResponseAnimation;
  String responseString;

  @override
  void initState() {
    // TODO: implement initState
    scaffoldKey = new GlobalKey();
    prepareAnimations();
    super.initState();
  }

  void prepareAnimations() {
    // This Controller is used for trembling the Circle consist of LOGO
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animationController.repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 10.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });

    // This Controller is used for Removing the Target of Circular logo after successful response from API
    targetController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    TargetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(targetController);
    TargetAnimation.addListener(() {
      setState(() {});
    });
    // This animation controller is used for animating the API response
    apiResponseController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    apiResponseAnimation =
        Tween<double>(begin: 0, end: 50).animate(apiResponseController);
    apiResponseAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // _runExpandCheck();
  }

  // Releasing memory to avoid memory leaks
  @override
  void dispose() {
    targetController.dispose();
    animationController.dispose();
    apiResponseController.dispose();
    super.dispose();
  }

  // _reset() Function is used to reset all the widgets to default position
  void _reset() {
    setState(() {
      isSuccess = false;
      showGIF = false;
      targetController.reverse();
      apiResponseController.reset();
    });
  }

  // API Call to check that is success or failure
  _getAPICall() async {
    String url ;//= successUrl;
    if(isToogleOn)
      url = successUrl;
    else
      url = failureUrl;
    http.Response response = await http.get(url);
    var res = jsonDecode(response.body);

    // if response status is 200 then showing success and 404 then Failure in Container and stopping all other animations
    if (response.statusCode == 200) {
      if (res['success'] == true)
        responseString = "SUCCESS";

    }else if(response.statusCode == 404){
      if (res['success'] == false)
        responseString = "FAILURE";

    }

    setState(() {
      showGIF = false;
      isSuccess = true;
      apiResponseController.forward();
      targetController.forward();
    });

  }

  _getArrowGIF() {
    return Visibility(
      visible: (!showGIF && !isSuccess),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          "gifs/arrowDowntrans.gif",
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          height: 100,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // _getWhiteContainer() function returns Top white Container
  _getWhiteContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: SizeConfig.screenWidth - 75,
        height: (SizeConfig.screenHeight / 2) - 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Visibility(
          visible: !showGIF && isSuccess,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin:
                    EdgeInsets.fromLTRB(0, 0, 0, apiResponseAnimation.value),
                child: Text(
                  responseString.toString(),
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // _getCircleWithLogo() function returns a Circular Container of logo which is used as
  _getCircleWithLogo() {
    return Visibility(
      visible: (!showGIF && !isSuccess), //flutter build apk --split-per-abi
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: Draggable(
          axis: Axis.vertical,
          data: 5,
          child: Card(
            margin: EdgeInsets.all(animation.value),
            color: Colors.black,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.screenHeight / 16),
            ),
            elevation: 10,
            child: Container(
              width: SizeConfig.screenHeight / 8,
              height: SizeConfig.screenHeight / 8,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight / 16),
                image: DecorationImage(
                  image: AssetImage("Images/logo.png"),
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
          feedback: Card(
            color: Colors.black,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.screenHeight / 16),
            ),
            elevation: 10,
            child: Container(
              width: SizeConfig.screenHeight / 8,
              height: SizeConfig.screenHeight / 8,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight / 16),
                image: DecorationImage(
                  image: AssetImage("Images/logo.png"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //_getTarget() function returns target required by the Circular Container
  _getTarget() {
    return SlideTransition(
      position: TargetAnimation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return showGIF == false
                    ? Center(
                        child: Container(
                          width: SizeConfig.screenHeight / 8,
                          height: SizeConfig.screenHeight / 8,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenHeight / 16),
                              border: Border.all(
                                  color: Colors.grey.shade800, width: 2.0)),
                        ),
                      )
                    : animatedloader; // Display Loader if source reaches target and hit API call after 3 seconds of load
              },
              onLeave: (data) {
                _toast("Circle Should reach a target");
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                setState(() {
                  showGIF = true;
                });
                // Waiting for GIF to complete it's rotations that's why making API call after 3 seconds.
                Future.delayed(Duration(seconds: 3), () {
                  _getAPICall();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initializing Screen sizes

    return Scaffold(
      backgroundColor: backColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Hello CRED",
          style: TextStyle(fontFamily: 'Sol Thin'),
        ),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            activeColor: Colors.black45,
            value: isToogleOn,
            onChanged: (val) {
              _toggle();
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: MaterialButton(
              minWidth: 0,
              height: 0,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(child: Text('Reset')),
              color: Colors.black,
              textColor: Colors.grey.shade300,
              onPressed: () {
                _reset();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: (SizeConfig.screenHeight / 2) + 75,
              child: Stack(
                children: [
                  _getWhiteContainer(),
                  _getArrowGIF(),
                  _getCircleWithLogo(),
                ],
              ),
            ),
            _getTarget(),
          ],
        ),
      ),
    );
  }

  _toast(String text) {
    Fluttertoast.showToast(
      msg: text,
    );
  }
  _toggle() {
    setState(() => isToogleOn = !isToogleOn);
  }

}
