/*

Utilized Brickles by Jon Bedard as a starting point

https://github.com/bedardjo/brickles

*/

import 'dart:math';

import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro/blocs/theme/theme_bloc.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/main.dart';

enum Game{running, fail}

abstract class GameObject {
  Offset position;
  Size size;

  GameObject({this.position, this.size});

  Widget render(Animation<double> controller, Size unitSize) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Positioned(
            top: position.dy * unitSize.height,
            left: position.dx * unitSize.width,
            width: size.width * unitSize.width,
            height: size.height * unitSize.height,
            child: renderGameObject(unitSize)),
      );

  Widget renderGameObject(Size unitSize);

  Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
}

class Ball extends GameObject {
  Offset direction;
  double speed;

  Ball({Offset position, this.direction, this.speed})
      : super(position: position, size: Size(0.6, 1.0));

  @override
  Widget renderGameObject(Size unitSize) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xffaaadaf), Colors.white,])
            
      ),
    );
  }
}

enum PowerUpType { length, balls, speed }

extension PowerUpProps on PowerUpType {
  Color get color {
    switch (this) {
      case PowerUpType.length:
        return Colors.red[300];
      case PowerUpType.speed:
        return Colors.red;
      case PowerUpType.balls:
        return Colors.yellow[300];
    }
    return Colors.red;
  }
}

class PowerUp extends GameObject {
  final PowerUpType type;
  PowerUp({Offset position, this.type})
      : super(position: position, size: Size(0.5, 1));

  @override
  Widget renderGameObject(Size unitSize) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(type.color, Colors.white, .1),
                  type.color,
                  Color.lerp(type.color, Colors.white, .1),
                  Color.lerp(type.color, Colors.black, .2),
                ]),
            
            borderRadius: BorderRadius.all(Radius.circular(16))),
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        );
  }
}

class Brick extends GameObject {
  Color color;

  Brick({Offset position, this.color})
      : super(position: position, size: Size(2, 1));

  @override
  Widget renderGameObject(Size unitSize) {
    return CustomPaint(painter: BrickPainter(brickColor: color));
  }

  /*Widget drawShadow(Size unitSize) {
    return Positioned(
        top: position.dy * unitSize.height,
        left: position.dx * unitSize.width,
        width: size.width * unitSize.width,
        height: size.height * unitSize.height,
        child: (Container(
            width: size.width * unitSize.width,
            height: size.height * unitSize.height,
            )));
  }*/
}

Paint stroke = Paint()
  ..strokeWidth = 1
  ..color = Colors.black
  ..style = PaintingStyle.stroke;

class BrickPainter extends CustomPainter {
  final Color brickColor;
  final Paint main;
  final Paint light;
  final Paint dark;

  BrickPainter({this.brickColor})
      : main = Paint()
          ..color = brickColor
          ..style = PaintingStyle.fill,
        light = Paint()
          ..color = Color.lerp(brickColor, Colors.white, .1)
          ..style = PaintingStyle.fill,
        dark = Paint()
          ..color = Color.lerp(brickColor, Colors.black, .1)
          ..style = PaintingStyle.fill;
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect inner = rect.deflate(3);
    canvas.drawRect(rect, main);
    canvas.drawPath(
        Path()
          ..moveTo(inner.left, inner.top)
          ..lineTo(rect.left, rect.top)
          ..lineTo(rect.right, rect.top)
          ..lineTo(inner.right, inner.top)
          ..lineTo(inner.left, inner.top),
        light);
    canvas.drawPath(
        Path()
          ..moveTo(inner.right, inner.top)
          ..lineTo(rect.right, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(inner.right, inner.bottom)
          ..lineTo(inner.right, inner.top),
        dark);
    canvas.drawPath(
        Path()
          ..moveTo(inner.left, inner.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(inner.right, inner.bottom)
          ..lineTo(inner.left, inner.bottom),
        dark);
    canvas.drawPath(
        Path()
          ..moveTo(inner.left, inner.top)
          ..lineTo(rect.left, rect.top)
          ..lineTo(rect.left, rect.bottom)
          ..lineTo(inner.left, inner.bottom)
          ..lineTo(inner.left, inner.top),
        dark);
    canvas.drawRect(rect, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Paddle extends GameObject {
  double speed = 10.0;

  bool left = false;
  bool right = false;

  double desiredLength = 3.0;

  Paddle({Offset position}) : super(position: position, size: Size(3.0, .7));

  @override
  Widget renderGameObject(Size unitSize) {
    return Container(
        
        child: Center(
          child: Container(
              width: (size.width * unitSize.width) * 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, const Color(0xff2a2a2a)])
                )
              ),
        ));
  }
}

class BreakoutGame extends StatefulWidget {
  BreakoutGame({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BreakoutGameState();
}

class BreakoutGameState extends State<BreakoutGame>
    with TickerProviderStateMixin {
  AnimationController controller;
  
  Game gameState;
  Size worldSize;
  Paddle paddle;
  List<Ball> balls;
  List<Brick> bricks;
  List<PowerUp> powerups;
  var _styleIndex = 1;
  var _colorful = false;
  var _showPercentNum = false;
  var _size = 13.0;
  var _ratio = 2.0;
  var _charging = false;

  int prevTimeMS = 0;

  int score;
  int level;
  bool isBreakoutGameOver;
  bool isPowerUp;

  @override
  void initState() {
    super.initState();
    isPowerUp = false;
    isBreakoutGameOver = false;
    gameState = Game.running;
    controller = AnimationController(vsync: this, duration: Duration(days: 99));
    controller.addListener(update);
    worldSize = Size(18.0, 28.0);
    level = 0;
    score = 0;
    paddle = Paddle(position: Offset(9.0 - 3.0 / 2, 27));
    balls = [
      Ball(
          position: Offset(0, 12),
          direction: Offset.fromDirection(.9),
          speed: 9)
    ];
    bricks = [];
    for(double i = 0; i < 18; i += 2){
      bricks.add(Brick(position: Offset(i, 0), color: Colors.red));
    }
    level++;
    powerups = [PowerUp(position: Offset(4.0, 8.0), type: PowerUpType.balls)]; /*[PowerUp(position: Offset(4.0, 7.0), type: PowerUpType.balls)];*/

    prevTimeMS = DateTime.now().millisecondsSinceEpoch;
    controller.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  void update() {
    int currTimeMS = DateTime.now().millisecondsSinceEpoch;
    int deltaMS = currTimeMS - prevTimeMS;
    double deltaS = deltaMS / 1000.0;

    List<Brick> destroyedBricks = [];
    List<PowerUp> consumedPowerups = [];
    List<Ball> lostBalls = [];

  
    Rect paddleRect = paddle.rect;

    for (PowerUp powerup in powerups) {
      powerup.position =
          Offset(powerup.position.dx, powerup.position.dy + 4.0 * deltaS);
      Rect powerupRect = powerup.rect;
      if (paddleRect.overlaps(powerupRect)) {
        consumedPowerups.add(powerup);
        score += 50;
        switch (powerup.type) {
          case PowerUpType.length:
            paddle.desiredLength += 0.6;
            break;
          case PowerUpType.speed:
            paddle.speed += 2.0;
            break;
          case PowerUpType.balls:
            balls.add(Ball(
                position: Offset(paddle.position.dx + paddle.size.width * .5,
                    paddle.position.dy - 1.0),
                direction: Offset.fromDirection(-.5),
                speed: 8.0));
            break;
        }
      }
    }

    for (Ball ball in balls) {
      ball.position = ball.position + ball.direction * ball.speed * deltaS;
      if (ball.position.dx + ball.size.width > worldSize.width) {
        ball.position =
            Offset(worldSize.width - ball.size.width, ball.position.dy);
        ball.direction = Offset(-ball.direction.dx, ball.direction.dy);
      }
      if (ball.position.dx < 0) {
        ball.position = Offset(0, ball.position.dy);
        ball.direction = Offset(-ball.direction.dx, ball.direction.dy);
      }
      if (ball.position.dy < 0) {
        ball.position = Offset(ball.position.dx, 0);
        ball.direction = Offset(ball.direction.dx, -ball.direction.dy);
      }
      if(ball.position.dy > 30){
          lostBalls.add(ball);
          if(balls.length == 1){
            setState(() {
              isBreakoutGameOver = true;
              gameState = Game.fail;
            });
          }
      }

      Rect ballRect = ball.rect;
      if (paddleRect.overlaps(ballRect)) {
        Rect intersection = ballRect.intersect(paddleRect);
        if (intersection.height < intersection.width &&
            ball.position.dy < paddle.position.dy) {
          // ball is hitting the face of the paddle
          ball.position =
              Offset(ball.position.dx, ball.position.dy - intersection.height);
          double paddlePct =
              (ball.position.dx + ball.size.width / 2 - paddle.position.dx) /
                  paddle.size.width;
          double maxAngle = pi * .8;
          ball.direction =
              Offset.fromDirection(-maxAngle + maxAngle * paddlePct);
        } else if (ball.position.dx < paddle.position.dx) {
          ball.position =
              Offset(paddle.position.dx - ball.size.width, ball.position.dy);
          ball.direction =
              Offset(-ball.direction.dx.abs(), ball.direction.dy.abs());
        } else if (ballRect.right > paddleRect.right) {
          ball.position = Offset(paddle.position.dx, ball.position.dy);
          ball.direction =
              Offset(-ball.direction.dx.abs(), ball.direction.dy.abs());
        } else {
          ball.position = Offset(ball.position.dx, paddleRect.bottom);
          ball.direction = Offset(0, ball.direction.dy.abs());
        }
      }

      for (Brick brick in bricks) {
        Rect brickRect = brick.rect;
        if (brickRect.overlaps(ballRect)) {
          score += 50;
          destroyedBricks.add(brick);
          Rect intersection = brickRect.intersect(ballRect);
          if (intersection.height > intersection.width) {
            ball.position = Offset(
                ball.position.dx - intersection.width * ball.direction.dx.sign,
                ball.position.dy);
            ball.direction = Offset(-ball.direction.dx, ball.direction.dy);
          } else {
            ball.position = Offset(
                ball.position.dx,
                ball.position.dy -
                    intersection.height * ball.direction.dy.sign);
            ball.direction = Offset(ball.direction.dx, -ball.direction.dy);
          }
          break;
        }
      }
    }

    if(bricks.isEmpty && level == 1){
        setState(() {
          for(double i = 0; i < 18; i+=2){
            bricks.add(Brick(position: Offset(i, 0), color: Colors.green));
            bricks.add(Brick(position: Offset(i, 1), color: Colors.yellow));
            //bricks.add(Brick(position: Offset(i, 2), color: Colors.red));
            //bricks.shuffle();
            powerups.add(PowerUp(position: Offset(6.0, 7.0), type: PowerUpType.balls));
            level++;
        }
      });
    }
    if(bricks.isEmpty && level == 2){
        setState(() {
          for(double i = 0; i < 18; i+=2){
            bricks.add(Brick(position: Offset(i, 0), color: Colors.green));
            bricks.add(Brick(position: Offset(i, 1), color: Colors.yellow));
            bricks.add(Brick(position: Offset(i, 2), color: Colors.red));
           // bricks.add(Brick(position: Offset(i, 3), color: Colors.blue));
            //bricks.shuffle();
            powerups.add(PowerUp(position: Offset(6.0, 3.0), type: PowerUpType.balls));
            i++;
            level++;
        }
      });
    }

    if (destroyedBricks.isNotEmpty || consumedPowerups.isNotEmpty || lostBalls.isNotEmpty) {
      setState(() {
        for (Brick destroyedBrick in destroyedBricks) {
          bricks.remove(destroyedBrick);
        }
        for (PowerUp powerup in consumedPowerups) {
          powerups.remove(powerup);
        }
        for (Ball ball in lostBalls) {
          balls.remove(ball);
        }
      });
    }
    prevTimeMS = currTimeMS;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (ThemeState prev, ThemeState cur) =>
          prev.skinTheme != cur.skinTheme,
      builder: (BuildContext context, ThemeState state) {
      return Container(
          //backgroundColor: Colors.transparent,
              child: Column(
                children: [
                  buildStatusBar(state),
                  _gameWidget()
          
                ],
              ),
          );
      });
  }

  Widget showGameScreen(){
    return Container(
          constraints: BoxConstraints(minHeight: 100, maxHeight: 270),
          height: 270, //displayHeight(context) * 0.4,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              Size unitSize = Size(
                  constraints.maxWidth / worldSize.width,
                  constraints.maxHeight / worldSize.height);
              List<Widget> gameObjects = [];
              gameObjects.add(paddle.render(controller, unitSize));
              gameObjects.addAll(
                  balls.map((b) => b.render(controller, unitSize)));
              
              gameObjects.addAll(
                  bricks.map((b) => b.render(controller, unitSize)));
              gameObjects.addAll(powerups
                  .map((b) => b.render(controller, unitSize)));
              return Stack(
                children: gameObjects,
              );
            },
        
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xff00bdff), const Color(0xff92e1ff)])
          )
      );
  }

  Widget showGameOver(){
     return Container(
          constraints: BoxConstraints(minHeight: 100, maxHeight: 270),
          height: 270, //displayHeight(context) * 0.328,
          width: double.infinity,
          child: Center(
            child: Text(
              "Game Over\n\nYou Scored: $score\n\nTap the select button to play again!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[300], fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff00bdff), const Color(0xff92e1ff)])
            )
        );

    }

  Widget _gameWidget(){
    switch(gameState){
      case Game.running:
        return showGameScreen();
      case Game.fail:
        return showGameOver();
    } return showGameScreen();
  }

  void restart() {
    setState(() {
      isBreakoutGameOver = false;
        controller = AnimationController(vsync: this, duration: Duration(days: 99));
        controller.addListener(update);
        worldSize = Size(18.0, 28.0);
        level = 0;
        score = 0;
        paddle = Paddle(position: Offset(9.0 - 3.0 / 2, 27));
        balls = [
          Ball(
              position: Offset(0, 12),
              direction: Offset.fromDirection(.9),
              speed: 9)
        ];
        bricks = [];
        for(double i = 0; i < 18; i += 2){
          bricks.add(Brick(position: Offset(i, 0), color: Colors.red));
        }
        level++;
        /*for(double i = 0; i < 18; i++){
          bricks.add(Brick(position: Offset(i, 0), color: Colors.red));
          bricks.add(Brick(position: Offset(i, 1), color: Colors.blue));
          i++;
          level++;
        }*/
        powerups = [PowerUp(position: Offset(4.0, 7.0), type: PowerUpType.balls)]; /*[PowerUp(position: Offset(4.0, 7.0), type: PowerUpType.balls)];*/

        prevTimeMS = DateTime.now().millisecondsSinceEpoch;
        controller.forward();
        gameState = Game.running;
      
    });
  }

  void moveLeft(){
    int currTimeMS = DateTime.now().millisecondsSinceEpoch;
    int deltaMS = currTimeMS - prevTimeMS;
    double deltaS = deltaMS / 45.0;
 
    if(paddle.position.dx > 0){
      setState(() {
        paddle.position = Offset(paddle.position.dx - paddle.speed * deltaS, paddle.position.dy);
      });
    }
  }

  void homePressed(context) async {
    setState(() => mainViewMode = MainViewMode.menu);
  }

  void moveRight(){
    int currTimeMS = DateTime.now().millisecondsSinceEpoch;
    int deltaMS = currTimeMS - prevTimeMS;
    double deltaS = deltaMS / 45.0;
    if (paddle.position.dx + paddle.size.width < worldSize.width) {
      setState(() {
        paddle.position = Offset(paddle.position.dx + paddle.speed * deltaS, paddle.position.dy);
      });
    }
  }


  Widget buildStatusBar(ThemeState state){
    return Container(
      height: 25,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Text(
              "$score",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
            SizedBox(width: 10),
            buildBatteryStatus(),
          ])
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF9A9B9E), Color(0xFFFFFFFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp),
          ), //menuCaptionStyle(state),
    );
  }

   Widget buildBatteryStatus() {
    /*battery.onBatteryStateChanged.listen((onData) {
      var charging = onData == BatteryState.charging;
      /*this.setState(() {
        _charging = charging;
      });*/
    });*/
     return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (ThemeState prev, ThemeState cur) =>
          prev.skinTheme != cur.skinTheme,
      builder: (BuildContext context, ThemeState state) {
    return Container(
    
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
     
        child: SizedBox(
          child: new Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_charging)
                  Icon(
                      Icons.bolt,
                      size: _size,
                      color: Colors.black),
                  BatteryIndicator(
                    style: BatteryIndicatorStyle.values[_styleIndex],
                    colorful: _colorful,
                    showPercentNum: _showPercentNum,
                    //mainColor: batteryColor(state),
                    size: _size,
                    ratio: _ratio,
                    //showPercentSlide: _showPercentSlide,
                  ),
                /*if (_charging)
                  Icon(
                    Icons.power,
                    size: _size,
                    color: Colors.black
                  ),*/
              ],
            ),
          ),
        ),
      )
    );
  });
  }



}

class Btn extends StatelessWidget {
  final void Function() down;
  final void Function() up;
  final Widget child;

  const Btn({Key key, this.down, this.up, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Center(child: child),
        ),
        onTapDown: (details) => down(),
        onTapCancel: up,
        onTapUp: (details) => up());
  }
}

class HexDecoration extends Decoration {
  final Color primaryColor;
  final double sideLength;

  HexDecoration({this.primaryColor, this.sideLength});

  @override
  BoxPainter createBoxPainter([void Function() onChanged]) {
    return HexPainter(primaryColor, sideLength);
  }
}

class HexPainter extends BoxPainter {
  final Color primaryColor;
  final double sideLength;

  HexPainter(this.primaryColor, this.sideLength);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Rect mainDrawingArea = Rect.fromLTWH(offset.dx, offset.dy,
        configuration.size.width, configuration.size.height);

    double halfHeight = (sideLength / 2.0) / tan(.523599);
    double height = halfHeight * 2.0;

    Offset p1 = Offset(0, 0);
    Offset p2 = Offset(sideLength, 0);
    Offset p3 = Offset(sideLength + halfHeight / 2, halfHeight);
    Offset p4 = Offset(sideLength, height);
    Offset p5 = Offset(0, height);
    Offset p6 = Offset(-halfHeight / 2, halfHeight);
    Offset mp1 = Offset(sideLength / 2, height / 3);
    Offset mp2 = Offset(sideLength / 2, height / 3 * 2);

    Map<List<Offset>, Paint> tris = {
      [p1, p2, mp1]: Paint()
        ..color = Color.lerp(primaryColor, Colors.black, .02)
        ..style = PaintingStyle.fill,
      [p2, p3, mp1]: Paint()
        ..color = Color.lerp(primaryColor, Colors.black, .01)
        ..style = PaintingStyle.fill,
      [p6, p1, mp1]: Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill,
      [p6, mp1, mp2]: Paint()
        ..color = Color.lerp(primaryColor, Colors.white, .03)
        ..style = PaintingStyle.fill,
      [mp1, mp2, p3]: Paint()
        ..color = Color.lerp(primaryColor, Colors.white, .06)
        ..style = PaintingStyle.fill,
      [p3, p4, mp2]: Paint()
        ..color = Color.lerp(primaryColor, Colors.white, .09)
        ..style = PaintingStyle.fill,
      [p4, p5, mp2]: Paint()
        ..color = Color.lerp(primaryColor, Colors.white, .12)
        ..style = PaintingStyle.fill,
      [p5, p6, mp2]: Paint()
        ..color = Color.lerp(primaryColor, Colors.white, .15)
        ..style = PaintingStyle.fill,
    };

    canvas.save();
    canvas.clipRect(mainDrawingArea);

    int row = 0;
    for (double y = -sideLength;
        y < configuration.size.height + height * 2;
        y += halfHeight) {
      for (double x = row % 2 == 0 ? sideLength + halfHeight / 2.0 : 0;
          x < configuration.size.width + sideLength;
          x += height + sideLength) {
        tris.forEach((t, value) {
          canvas.drawPath(
              Path()
                ..moveTo(t[0].dx + x, t[0].dy + y)
                ..lineTo(t[1].dx + x, t[1].dy + y)
                ..lineTo(t[2].dx + x, t[2].dy + y),
              value);
        });
      }
      row++;
    }
    canvas.restore();
  }
}