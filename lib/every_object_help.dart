import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/shared_preferences.dart';

class EveryObjectHelp extends StatefulWidget {


  final image;
  final descriptionAR;
  final descriptionEN;

  final name;
  final page;

  EveryObjectHelp({required this.image,required this.descriptionAR,required this.descriptionEN,required this.name,required this.page});

  @override
  State<EveryObjectHelp> createState() => _EveryObjectHelpState();
}

class _EveryObjectHelpState extends State<EveryObjectHelp> {

  Future<void> speakTextEnglish(String text) async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }


  Future<void> speakTextArabic(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar-SA'); // تعيين اللغة العربية
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1); // تعيين المد
    await flutterTts.speak(text);
  }

  @override
  void initState() {

    cachHelper.getData(key: 'lang')=='ar' ? speakTextArabic(widget.descriptionAR) : speakTextEnglish(widget.descriptionEN) ;

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leadingWidth: 66,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child:Column(
            children: [


              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // الوصف بتنسيق جميل
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // تغير موقع الظل
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Your ${widget.name} Recognition',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        cachHelper.getData(key: 'lang') == 'ar' ? widget.descriptionAR : widget.descriptionEN,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),


                      SizedBox(
                        height: 40,
                      ),


                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.page));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: backgroundColor,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
