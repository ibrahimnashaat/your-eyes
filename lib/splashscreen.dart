import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/main_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool? isLogin;

  void speakText(String text) async {
    FlutterTts flutterTts = FlutterTts();

    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setPitch(1);
    // await flutterTts.speak(text);

    await flutterTts.setLanguage('ar-SA'); // تعيين اللغة العربية
    await flutterTts.setSpeechRate(0.5); // تعيين معدل النطق
    await flutterTts.setPitch(1); // تعيين المد
    await flutterTts.speak(text);
  }


  @override
  void initState() {
    super.initState();
   // speakText('welcome to your eyes application');
   speakText('مرحبا بك في تطبيق your eyes');
    Timer(
        const Duration(seconds: 5),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HomeScreen() ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: height,
        width: width,

        child: Stack(

          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset('assets/images/pic.jpeg',
               width : MediaQuery.of(context).size.width,
                        height : MediaQuery.of(context).size.height,
                fit: BoxFit.cover,



              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Spacer(),

                  Image.asset('assets/images/logo.png',
                  width: 150,
                    height: 180,
                    color: Colors.white70,
                  ),

                  const Text(
                    'your eyes',
                    style: TextStyle(
                      fontFamily: 'Kidstar',
                      fontSize: 50.0,
                      color: Colors.white70,
                    ),
                  ),


                 const Spacer(),
                  const CircularProgressIndicator(
                    color: Colors.white70,
                  ),

                  const SizedBox(
                    height: 30.0,
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
