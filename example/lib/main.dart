import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    GameManager.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Demo'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: TextButton(
          onPressed: (){
            GameManager().launchGame(context,
                gameSettings: GameSettings(
                  ballCount: BallCount.four,
                  ballShape: BallShape.circle,
                  ballSize: 50.0,
                  gameSpeed: GameSpeed.normal
                ));
          },
          child: const Text("Play Game"),
        ),
      ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
