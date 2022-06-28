import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {

  //Now lets start by creating our music player
  //First lets declare some object
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    setAudio();

    super.initState();

    player.onPlayerStateChanged.listen((state) {
      setState((){
        isPlaying = (state == PlayerState.playing);
      });
    });


    //listen to audio duration
    player.onDurationChanged.listen((newDuration){
      duration = newDuration;
    });
    //listen to audio position
    player.onPositionChanged.listen((newPosition) {
      setState((){
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String? time(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours > 0) hours,
      minutes,
      seconds
    ].join(":");
  }

  Future setAudio() async{
    player.setReleaseMode(ReleaseMode.loop);
    String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3";
    player.setSourceUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //lets start by creating the main UI of the app
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://www.ilmubahasainggris.com/wp-content/uploads/2017/03/NGC.jpg",
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              )
            ),
            const SizedBox(height: 32),
            const Text(
              "The flutter song",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Muntasir',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async{
                  final position = Duration(seconds: value.toInt());
                  await player.seek(position);

                  await player.resume();
                }),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time(position) ?? ""),
                  Text(time(duration - position) ?? "")
                ],
              ),
            ),
            IconButton(
                onPressed: () async{
                  if(isPlaying){
                    await player.pause();
                  }else{
                    await player.resume();
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
            )
          ],
        )
      ),
    );
  }
}

