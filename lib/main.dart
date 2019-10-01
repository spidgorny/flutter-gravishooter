import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;
  AudioCache audioCache = new AudioCache();
  AudioPlayer player;
  double prevZ = 0;

  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      //print(event);
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      //print(event);
      setState(() {
        _counter = event.z;
      });
      double zDiff = event.z - prevZ;
      if (zDiff > 5) {
        this._incrementCounter(zDiff);
      }
      prevZ = event.z;
    });
  }

  void _incrementCounter(double gyroZ) async {
//    if (player == null) {
    print('Play: ' + gyroZ.toString());
    player = await audioCache.play('40_smith_wesson_single-mike-koenig.mp3');
    player.completionHandler = () {
      print('Completed');
      player = null;
    };
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
