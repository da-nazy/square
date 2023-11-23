import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestures and Animations',
      home: Scaffold(
        body: Center(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

// mixin provides one sticker calls callback per animation frame
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? controller;
  int numTaps = 0;
  int numDoubleTaps = 0;
  int numLongPress = 0;
  double posX = 0.0;
  double posY = 0.0;
  double boxSize = 0.0;
  double fullBoxSize = 150.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeInOut);
    animation!.addListener(() {
      setState(() {
        boxSize = fullBoxSize * animation!.value;
      });
      center(context);
    });
    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (posX == 0.0) {
      // when the app loads for the first time
      center(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gesture and Animations"),
      ),
      body: GestureDetector(
          onTap: () {
            setState(() {
              numTaps++;
            });
          },
          onDoubleTap: () {
            setState(() {
              numDoubleTaps++;
            });
          },
          onLongPress: () {
            setState(() {
              numLongPress++;
            });
          },
          onVerticalDragUpdate: (DragUpdateDetails value) {
            setState(() {
              // read length of movement performed by the user
              double delta = value.delta.dy;
              posY += delta;
            });
          },
          onHorizontalDragUpdate: (DragUpdateDetails value) {
            setState(() {
              // read length of movement performed by the user
              double delta = value.delta.dx;
              posX += delta;
            });
          },
          child: Stack(children: <Widget>[
            Positioned(
                left: posX,
                top: posY,
                child: Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    )))
          ])),
      bottomNavigationBar: Material(
          color: Theme.of(context).primaryColorLight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Taps: $numTaps - Double Taps: $numDoubleTaps - Long Presses: $numLongPress",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )),
    );
  }

// clean up resources overriding the dispos method
  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  void center(BuildContext context) {
    // give the size and orientation of parent size
    posX = (MediaQuery.of(context).size.width / 2) - boxSize / 2;
    posY = (MediaQuery.of(context).size.width / 2) - boxSize / 2 - 30.0;
    setState(() {
      posX = posX;
      posY = posY;
    });
  }
}
