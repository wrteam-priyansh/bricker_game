import 'dart:async';

import 'package:brick_wall/widgets/ballContaienr.dart';
import 'package:brick_wall/widgets/platformContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const double ballWidth = 20.0;
const double ballHeight = 20.0;
const double platformHeight = 10.0;
enum BallDirection { DOWN, UP }

class _HomeScreenState extends State<HomeScreen> {
  bool isReadyToPlay = false;
  late double ballX = 0.5;
  late double ballY = 0.5;
  BallDirection ballCurrentDirection = BallDirection.DOWN;

  late double platFormWidth;
  late double platFormX;

  late double platFormY;

  late Timer? timer;
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      screenSize = MediaQuery.of(context).size;
      ballX = screenSize.width * (0.5) - ballWidth * (0.5);
      ballY = screenSize.width * (0.5) - ballHeight * (0.5);
      platFormWidth = screenSize.width * (0.15);
      platFormY = screenSize.height * (0.2); //from bottom
      platFormX = screenSize.width * (0.5) - platFormWidth;
      isReadyToPlay = true;
      setState(() {});
    });
  }
/*
  void startTimer(Size screenSize) {
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      changeBallDirection(screenSize);
      moveBall();
    });
  }

  void moveBall() {
    setState(() {
      //alignment 1.0 is in bottom
      if (ballCurrentDirection == BallDirection.DOWN) {
        //move down
        ballYPercentage += 0.005;
      } else if (ballCurrentDirection == BallDirection.UP) {
        //alignment 1.0 is in up side
        //move up
        ballYPercentage -= 0.005;
      }
    });
  }
  

  void changeBallDirection(Size screenSize) {
    setState(() {
      if (ballYPercentage >= (screenSize.height * platFormYPercentage - ballHeight)) {
        ballCurrentDirection = BallDirection.UP;
      } else if (ballYPercentage <= (0.0 + platFormYPercentage)) {
        ballCurrentDirection = BallDirection.DOWN;
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isReadyToPlay
          ? RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (key) {
                if (key.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  if (platFormX > 0.0) {
                    platFormX = platFormX - 25;
                    setState(() {});
                  }
                } else if (key.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  if (platFormX < (screenSize.width - platFormWidth)) {
                    platFormX = platFormX + 25;
                    setState(() {});
                  }
                }
              },
              autofocus: true,
              child: GestureDetector(
                onTap: () {
                  //startTimer();
                },
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.deepPurple[100]),
                    ),
                    Positioned(
                      left: ballX,
                      top: ballY,
                      child: BallContainer(),
                    ),
                    Positioned(
                      bottom: platFormY,
                      left: platFormX,
                      child: PlatformContainer(
                        width: platFormWidth,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
