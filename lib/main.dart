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
      home: MyHomePage(title: 'Gravi-Shooter'),
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
  String selectedGunSound = '40_smith_wesson_single-mike-koenig.mp3';
  var zOrientation = 0.0;
  var playStartTime = DateTime.now();

  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      zOrientation = event.x;
      print(event);
    });

    gyroscopeEvents.listen(gyroEvent);
  }

  void gyroEvent(GyroscopeEvent event) {
    //print(event);
    double zDiff = event.z - prevZ;
    if (zOrientation > 11 && zDiff.abs() > 4) {
      print("*** " +
          zOrientation.toStringAsFixed(2) +
          "\t" +
          zDiff.toStringAsFixed(2));
      this._incrementCounter(zDiff);
    } else {
      if (zDiff.toStringAsFixed(2) != '0.00' &&
          zDiff.toStringAsFixed(2) != '-0.00') {
//        print(
//            zOrientation.toStringAsFixed(2) + "\t" + zDiff.toStringAsFixed(2));
      }
    }
    setState(() {
      _counter = zDiff;
    });
    prevZ = event.z;
  }

  void _incrementCounter(double gyroZ) async {
    var shootTimeDiff = DateTime.now().difference(playStartTime).inMilliseconds;
    if (shootTimeDiff < 300) {
      print('Skip double shooting');
    } else {
      print('Play: ' + gyroZ.toString());
      player = await audioCache.play(selectedGunSound);
      playStartTime = DateTime.now();
      player.completionHandler = () {
        print('Completed');
        player = null;
      };
    }
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
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildGunButton('assets/GLOCK_17_Gen_4_Pistol_MOD_45160305.png',
                '40_smith_wesson_single-mike-koenig.mp3'),
            buildGunButton('assets/Trench_Shotgun_win12_800.jpg',
                'Winchester12-RA_The_Sun_God-1722751268.mp3'),
            buildGunButton('assets/MP5K_Submachine_Gun_(7414624602).jpg',
                'MP5_SMG-GunGuru-703432894.mp3'),
            buildGunButton('assets/pvw59324.gif',
                '8d82b5_Star_Wars_Laser_Sound_Effect.mp3'),
            Text(
              _counter.toStringAsFixed(2),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._incrementCounter(0);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding buildGunButton(picture, sound) {
    var isSelected = selectedGunSound == sound;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: Colors.black, width: 5)
                  : Border.all(color: Colors.grey.shade50, width: 5),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Image.asset(picture)),
        onTap: () {
          this.selectedGunSound = sound;
        },
      ),
    );
  }
}
