import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

import 'confirm_dialog.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  int best = 0;
  int score = 0;
  double initHeight = birdYAxis;
  bool hasGameStarted = false;

  static double barrierX1 = 1;
  double barrierX2 = barrierX1 + 1.5;
  static const double barrierY1 = 1.1;
  static const double barrierWidth = 100;
  static const double barrierAdjust = 0.5;
  static const double barrierHeight1 = 200.0;
  static const double barrierHeight1InPercent =
      (barrierHeight1 / barrierHeight1) * barrierAdjust;
  static const double barrierHeight2 = barrierHeight1;
  static const double barrierHeight2InPercent = -barrierHeight1InPercent;
  static const double barrierHeight3 = 150.0;
  static const double barrierHeight3InPercent =
      (barrierHeight3 - 50) / barrierHeight3;
  static const double barrierHeight4 = 250.0;
  static const double barrierHeight4InPercent =
      -(barrierHeight4 - 60) / barrierHeight4;
  static const double barrierWidthInPercentDevBy2 =
      barrierWidth / (barrierWidth * 2);

  void reset() {
    hasGameStarted = false;
    birdYAxis = 0;
    initHeight = 0;
    height = 0;
    time = 0;
    barrierX1 = 1;
    barrierX2 = barrierX1 + 1.5;
    if (score > best) {
      best = score;
    }
    score = 0;
  }

  void jump() {
    setState(() {
      time = 0;
      initHeight = birdYAxis;
    });
  }

  double increaseXValue(double barrierXX) {
    double barierX = barrierXX;
    setState(() {
      if (barrierXX < -2) {
        barierX += 3.5;
        score++;
      } else {
        barierX -= 0.05;
      }
    });
    return barierX;
  }

  void gameOver() {
    setState(() {
      reset();
    });
  }

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      calcNewHeight();
      barrierX1 = increaseXValue(barrierX1);
      barrierX2 = increaseXValue(barrierX2);
      if (barrierX1 >= 0 && barrierWidthInPercentDevBy2 >= barrierX1 ||
          barrierX2 >= 0 && barrierWidthInPercentDevBy2 >= barrierX2) {
        if (birdYAxis >= barrierHeight1InPercent ||
            birdYAxis <= barrierHeight2InPercent ||
            birdYAxis >= barrierHeight3InPercent ||
            birdYAxis <= barrierHeight4InPercent) {
          cancleTheGame(timer);
        }
      }
      if (birdYAxis > 1.1) {
        cancleTheGame(timer);
      }
    });
  }

  void cancleTheGame(Timer timer) {
    timer.cancel();
    ConfirmDialog.showPlayAgain(context, gameOver, score.toString());
  }

  void calcNewHeight() {
    time += 0.05;
    height = -4.9 * time * time + 2.8 * time;
    setState(() {
      birdYAxis = initHeight - height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (hasGameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYAxis),
                    color: Colors.blue,
                    duration: const Duration(),
                    child: Bird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: hasGameStarted
                        ? const Text('')
                        : const Text(
                            'T A B  TO  P L A Y',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                      alignment: Alignment(barrierX1, barrierY1),
                      duration: const Duration(),
                      child: const Barriers(
                          height: barrierHeight1, width: barrierWidth)),
                  AnimatedContainer(
                      alignment: Alignment(barrierX1, -barrierY1),
                      duration: const Duration(),
                      child: const Barriers(
                          height: barrierHeight2, width: barrierWidth)),
                  AnimatedContainer(
                      alignment: Alignment(barrierX2, barrierY1),
                      duration: const Duration(),
                      child: const Barriers(
                          height: barrierHeight3, width: barrierWidth)),
                  AnimatedContainer(
                      alignment: Alignment(barrierX2, -barrierY1),
                      duration: const Duration(),
                      child: const Barriers(
                          height: barrierHeight4, width: barrierWidth)),
                ],
              )),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        score.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'BEST',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        best.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
