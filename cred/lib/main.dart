import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Constants/API.dart';
import 'Constants/size_config.dart';
import 'Constants/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        appContext: context,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  BuildContext appContext;

  MyHomePage({Key key, this.title, this.appContext}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isSuccess = false, showGIF = false;
  AnimationController bottomController, apiRespController;
  Animation<Offset> animationVisibility, apiRespVisibility;
  String responseString;

  @override
  void initState() {
    // TODO: implement initState
    scaffoldKey = new GlobalKey();
    prepareAnimations();

    print("Size Height " + SizeConfig.screenHeight.toString());
    print("Size Width " + SizeConfig.screenWidth.toString());
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 10.0).animate(_animationController);
    super.initState();
  }

  void prepareAnimations() {
    bottomController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationVisibility =
        Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
            .animate(bottomController);
    animationVisibility.addListener(() {
      setState(() {});
    });
    apiRespController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    apiRespVisibility = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(apiRespController);
    apiRespVisibility.addListener(() {
      setState(() {});
    });
  }

  void _runExpandCheck() {
    if (isSuccess) {
      print('WIdget updated');
      bottomController.forward();
    } else {
      bottomController.reverse();
    }
  }

  void _reset() {
    setState(() {
      isSuccess = false;
      showGIF = false;
      bottomController.reverse();
    });
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // _runExpandCheck();
  }

  @override
  void dispose() {
    bottomController.dispose();
    _animationController.dispose();
    apiRespController.dispose();
    super.dispose();
  }

  _getSuccessCall() async {
    String url = successUrl;
    http.Response response = await http.get(url);
    print((jsonDecode(response.body)).toString());
    var res = jsonDecode(response.body);
    print(res["success"].toString());
    if (response.statusCode == 200) {
      if (res['success'] == true) responseString = "SUCCESS";
      print(responseString);
      apiRespVisibility = Tween<Offset>(
              begin: Offset(
                  (SizeConfig.screenWidth / 2), (SizeConfig.screenHeight / 2)+100),
              end: Offset.zero)
          .animate(apiRespController);
      setState(() {
        showGIF = false;
        isSuccess = true;
        apiRespController.forward();
        bottomController.forward();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: backColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Hello Cred"),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
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
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: (SizeConfig.screenHeight / 2) + 75,
              child: Stack(
                // alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      // padding: EdgeInsets.all(50.0),
                      width: SizeConfig.screenWidth - 75,
                      height: (SizeConfig.screenHeight / 2) - 75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SlideTransition(
                        position: apiRespVisibility,
                        child: Visibility(
                          visible: !showGIF && isSuccess,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.red,
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  responseString.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (!showGIF && !isSuccess),
                    // maintainAnimation: true,
                    // maintainSize: true,
                    // maintainState: true,
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
                  ),
                  Visibility(
                    visible: (!showGIF && !isSuccess),
                    // maintainAnimation: true,
                    // maintainSize: true,
                    // maintainState: true,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 75),
                      child: Draggable(
                        axis: Axis.vertical,
                        data: 5,
                        child: Card(
                          margin: EdgeInsets.all(_animation.value),
                          color: Colors.black,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight / 16),
                          ),
                          elevation: 10,
                          child: Container(
                            width: SizeConfig.screenHeight / 8,
                            height: SizeConfig.screenHeight / 8,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenHeight / 16),
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
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight / 16),
                          ),
                          elevation: 10,
                          child: Container(
                            width: SizeConfig.screenHeight / 8,
                            height: SizeConfig.screenHeight / 8,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenHeight / 16),
                              image: DecorationImage(
                                image: AssetImage("Images/logo.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SlideTransition(
              position: animationVisibility,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: DragTarget(
                      builder:
                          (context, List<int> candidateData, rejectedData) {
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
                                          color: Colors.grey.shade800,
                                          width: 2.0)
                                      // image: DecorationImage(
                                      //   image: AssetImage("Images/logo.png"),
                                      // ),
                                      ),
                                ),
                              )
                            : animatedloader;
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

                        Future.delayed(Duration(seconds: 5), () {
                          _getSuccessCall();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _toast(String text) {
    Fluttertoast.showToast(
      msg: text,
    );
  }
}
