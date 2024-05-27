import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart'as stt;

import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/main_screen.dart';
import 'package:your_eyes/shared_preferences.dart';
import 'package:your_eyes/text_detection/text_detection.dart';
import 'package:your_eyes/time_detection/time_detection.dart';

import 'color_detection/color_detection.dart';
import 'date_detection/date_detection.dart';
import 'face_detection/face_detection.dart';
import 'help.dart';
import 'object_detection/object_detection.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late stt.SpeechToText _speech;
  bool? isLogin;

  void speakText(String text) async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    // await flutterTts.setLanguage('ar-SA'); // تعيين اللغة العربية
    // await flutterTts.setSpeechRate(0.5); // تعيين معدل النطق
    // await flutterTts.setPitch(1); // تعيين المد
    // await flutterTts.speak(text);
  }


  bool _isListening = false;
  String _text = 'Initializing...';
  double _confidence = 1.0;



  // void _listenContinuously() async {
  //   bool available = await _speech.initialize(
  //     onStatus: (val) => _statusListener(val),
  //     // onError: (val) => _errorListener(val),
  //   );
  //
  //   if (available) {
  //     _startListening();
  //   } else {
  //     setState(() {
  //       _isListening = false;
  //       _text = "Speech recognition not available on this device";
  //     });
  //   }
  // }
  //
  // void _startListening() {
  //   setState(() => _isListening = true);
  //   _speech.listen(
  //     onResult: (val) => setState(() {
  //       _text = val.recognizedWords;
  //       print(_text);
  //       if (val.hasConfidenceRating && val.confidence > 0) {
  //         _confidence = val.confidence;
  //       }
  //       _navigateBasedOnCommand(_text);
  //
  //     }),
  //     localeId: 'en_US',
  //   );
  // }
  //
  //
  //
  //
  // void _statusListener(String status) {
  //   if (status == 'done' || status == 'notListening') {
  //     _startListening();
  //   }
  // }

  bool _isPermissionGranted = false;

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;

    cachHelper.saveData(key: 'cameraIsOpen', value: _isPermissionGranted);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();


    _requestCameraPermission();

    _animateText();

   // speakText('welcome to your eyes application');
   speakText('All You Need In One Place');


    //
    // _speech = stt.SpeechToText();
    //       _listenContinuously();

          Timer(const Duration(seconds: 5), () {

            if (cachHelper.getData(key: 'lang') != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>  MainScreen() ),(route)=>false
              );
            }


          });


  }


 // void  _navigateBasedOnCommand(String command) {
 //    switch (command) {
 //      case 'letters':
 //          Navigator.push(context,MaterialPageRoute(builder: (context)=> TextDetection()));
 //        break;
 //      case 'object':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> ObjectDetection()));
 //        break;
 //      case 'colour':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> ColorDetection()));
 //        break;
 //      case 'time':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> TimeDetection()));
 //        break;
 //      case 'history':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> DateDetection()));
 //        break;
 //      case 'human':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> FaceDetection()));
 //        break;
 //      case 'help me':
 //        Navigator.push(context,MaterialPageRoute(builder: (context)=> Help(isArabic: cachHelper.getData(key: 'lang') == 'ar' ? true : false,)));
 //        break;
 //      default:
 //        break;
 //    }
 //  }


  List<String> texts = ['All You Need', 'In', 'One Place'];
  List<bool> visible = [false, false, false];



  void _animateText() {
    for (int i = 0; i < texts.length; i++) {
      Future.delayed(Duration(milliseconds: i * 1000), () {
        setState(() {
          visible[i] = true;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(

      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(


            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.12,
              ),

              Row(
                children: [

                  SizedBox(

                    width: MediaQuery.of(context).size.width*0.52,
                    height: MediaQuery.of(context).size.height*0.28,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape:BoxShape.circle,
                            boxShadow: [
                              BoxShadow(

                                  color: Colors.grey,
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0.0, 0.0)
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 95,
                            backgroundColor: backgroundColor,
                            backgroundImage:  const AssetImage('assets/images/img_3.png',

                            ) ,

                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(

                    width: MediaQuery.of(context).size.width*0.48,
                    height: MediaQuery.of(context).size.height*0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape:BoxShape.circle,
                            boxShadow: [
                              BoxShadow(

                                  color: Colors.grey,
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0.0, 0.0)
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: backgroundColor,
                            backgroundImage:  const AssetImage('assets/images/img_1.png',

                            ) ,

                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Column(


                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape:BoxShape.circle,
                            boxShadow: [
                              BoxShadow(

                                  color: Colors.grey,
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: Offset(0.0, 0.0)
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 120,
                            backgroundColor: backgroundColor,
                            backgroundImage:  const AssetImage('assets/images/img_2.png',

                            ) ,

                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(texts.length * 2 - 1, (index) {
                  if (index.isEven) {
                    int textIndex = index ~/ 2;
                    return AnimatedOpacity(
                      opacity: visible[textIndex] ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        texts[textIndex],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontFamily: 'Kidstar',
                          wordSpacing: 1,
                          height: 0.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return SizedBox(height: 15); // التحكم في المسافة بين النصوص
                  }
                }),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Opacity(
              //       opacity: 0.5,
              //       child: Image.asset('assets/images/img.png',
              //         width: 200,
              //
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 30.0),
              //       child: CircularProgressIndicator(
              //         color: Colors.white54,
              //
              //       ),
              //     ),
              //   ],
              // ),




            ],


          ),
        ),

      ),
    );
  }
}
