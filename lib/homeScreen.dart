import 'dart:async';

import 'package:brick_wall/models/brick.dart';
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
const double defaultTopBrickPadding = 10;
const double brickWidthPercentage = 0.175;
const double brickHeightPercentage = 0.03;
const double inbetweenBrickSpace = 10.0;
const int totalBrickRow = 3;
const int bricksInRow = 5;
const double bricksHorizontalPadding = 70;

enum BallDirection { DOWN, UP, LEFT, RIGHT }

class _HomeScreenState extends State<HomeScreen> {
  bool isReadyToPlay = false;
  late double ballX = 0.5;
  late double ballY = 0.5;
  BallDirection ballVerticalDirection = BallDirection.UP;

  BallDirection ballHorizontalDirection = BallDirection.LEFT;

  late double platFormWidth;
  late double platFormX;

  late double platFormY;

  late Timer? timer;
  late Size screenSize;
  late double ballMoveYPixels = 3.0;

  late List<Brick> bricks = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initGame();
      addBricks();
      isReadyToPlay = true;
      setState(() {});
    });
  }

  void initGame() {
    screenSize = MediaQuery.of(context).size;
    ballX = screenSize.width * (0.5) - ballWidth * (0.5);
    ballY = screenSize.height * (0.5) - ballHeight * (0.5);
    platFormWidth = screenSize.width * (0.15);
    platFormY = screenSize.height * (0.025); //from bottom
    platFormX = screenSize.width * (0.5) - platFormWidth * (0.5);
  }

  double _calculateBrickX(int currentBrickIndex) {
    double brickX = bricksHorizontalPadding;

    for (var i = currentBrickIndex; i > 0; i--) {
      brickX = screenSize.width * brickWidthPercentage + brickX + inbetweenBrickSpace;
    }

    return brickX;
  }

  double _calculateBrickY(int currentRowIndex) {
    double brickY = defaultTopBrickPadding;

    for (var i = currentRowIndex; i > 0; i--) {
      brickY = screenSize.height * brickHeightPercentage + brickY + defaultTopBrickPadding;
    }

    return brickY;
  }

  void addBricks() {
    for (var i = 0; i < totalBrickRow; i++) {
      for (var j = 0; j < bricksInRow; j++) {
        bricks.add(Brick(
          bricX: _calculateBrickX(j),
          brickHeight: screenSize.height * brickHeightPercentage,
          brickWidth: screenSize.width * brickWidthPercentage,
          brickY: _calculateBrickY(i),
          broken: false,
        ));
      }
    }
  }

  void startTimer(Size screenSize) {
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      breakBricks();
      changeBallDirection(screenSize);
      moveBall();
    });
  }

  void moveBall() {
    setState(() {
      if (ballVerticalDirection == BallDirection.DOWN) {
        ballY += ballMoveYPixels;
      } else if (ballVerticalDirection == BallDirection.UP) {
        ballY -= ballMoveYPixels;
      }

      if (ballHorizontalDirection == BallDirection.RIGHT) {
        ballX += ballMoveYPixels;
      } else if (ballHorizontalDirection == BallDirection.LEFT) {
        ballX -= ballMoveYPixels;
      }
    });
  }

  void changeBallDirection(Size screenSize) {
    setState(() {
      //maximum ball can go to the down side
      if (ballY > (screenSize.height - platFormY - platformHeight - ballHeight)) {
        //need to check if ball is touching the platform or not
        if (ballX >= platFormX && ballX <= platFormX + platFormWidth) {
          ballVerticalDirection = BallDirection.UP;
        } else {
          //user failed to bounce the ball back
          timer?.cancel();
        }
      } else if (ballY < defaultTopBrickPadding) {
        ballVerticalDirection = BallDirection.DOWN;
      }

      //change ballX direction
      if (ballX < 0) {
        ballHorizontalDirection = BallDirection.RIGHT;
      } else if (ballX > screenSize.width) {
        ballHorizontalDirection = BallDirection.LEFT;
      }
    });
  }

  void breakBricks() {
    for (var i = (bricks.length - 1); i >= 0; i--) {
      Brick brick = bricks[i];
      if (!brick.broken) {
        //check for ballY has in the range of brickY
        if (ballY >= brick.brickY && ballY <= brick.brickY + brick.brickHeight) {
          //check for ballX has in range of brickY
          if (ballX >= brick.bricX && ballX <= brick.bricX + brick.brickWidth) {
            bricks[i] = brick.breakBrick();

            ballVerticalDirection = BallDirection.DOWN;
            setState(() {});
            break;
          }
        }
      }
    }
  }

  Widget _buildBrick(Brick brick) {
    return brick.broken
        ? Container()
        : Positioned(
            top: brick.brickY,
            left: brick.bricX,
            child: Container(
              width: brick.brickWidth,
              height: brick.brickHeight,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.deepPurple),
            ));
  }

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
                  //print(defaultTopBrickPadding + bricks.first.brickHeight);
                  startTimer(screenSize);
                },
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.deepPurple[100]),
                    ),
                    ...bricks.map((brick) => _buildBrick(brick)).toList(),
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
