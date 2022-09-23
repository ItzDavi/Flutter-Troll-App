import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:video_player/video_player.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool firstTimeEleven = true;

  bool tenPressed = false;
  bool loadingDoubleTapped = false;

  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.asset('assets/videos/video.mp4');
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value){
      setState(() {controller.play();});
    });
  }

  void manageCounter() {

    if (counter < -3) {
      counter += 3;

    }else if (counter >= -3 && counter < 9) {
      counter++;

    } else if (counter == 9) {
      counter += 2;

    } else if (counter >= 11 && counter < 19) {
      if (firstTimeEleven) {
        counter = 5;
        firstTimeEleven = false;

      } else {
        counter += 2;
      }

    } else if (counter >= 19 && counter < 20) {
      if (!firstTimeEleven) {
        counter -= 5;
      }

    } else if (counter == 20) {
      counter = -300;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: RichText(
                    text: TextSpan(
                        children: <TextSpan>[
                           const TextSpan(
                              text: 'Can you reach ',
                              style: TextStyle(color: Colors.blue, fontSize: 40.0)),
                          TextSpan(
                              text: '10',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 40.0),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                    setState(() {
                                      tenPressed = true;
                                    });
                                }),
                          const TextSpan(text: '?', style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40.0)
                          ),
                        ]
                    ),
                  ),
                 ),
                Padding(
                  padding: const EdgeInsets.only(top: 280.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: !tenPressed,
                        child: Text(
                          '$counter',
                          style: const TextStyle(
                              fontSize: 48.0, color: Colors.blue)
                          ,),
                      ),
                      Visibility(
                        visible: tenPressed && !loadingDoubleTapped,
                        child: GestureDetector(
                          child: const CircularProgressIndicator(color: Colors.blue,),
                          onDoubleTap: () {
                              setState(() {
                                loadingDoubleTapped = true;
                              });
                          },
                        ),
                      ),
                      Visibility(
                        visible: loadingDoubleTapped,
                          child: VideoPlayer(controller)
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                    const EdgeInsets.only(
                        top: 180.0),
                  child:
                    Column(
                      children: [
                        Visibility(
                          visible: loadingDoubleTapped,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.initialize();
                                  controller.play();
                                });
                              },
                              icon: const Icon(Icons.play_arrow_rounded, color: Colors.blue,)
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              manageCounter();
                              });
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 120.0
                                )
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(
                                      width: 1.0,
                                      color: Colors.blue,
                                      style: BorderStyle.solid)
                              )
                            )
                          ),
                          child:
                            const Text(
                              '+1',
                              style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

