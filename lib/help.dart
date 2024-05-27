import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_eyes/constants/colors.dart';

class Help extends StatefulWidget {


  bool isArabic ;

  Help({required this.isArabic});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {

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

    widget.isArabic ? speakTextArabic('كيف تقوم بإلتقاط الصور'

    'يمكنك بعد الدخول على التطبيق أن تضغط على أي مكان في الشاشة لألتقاط صورة وسماع الكلمات الموجودة في الصورة.'
    'كيف تقوم بتغيير اللغة داخل التطبيق'
        'يمكنك بعد الدخول على التطبيق أن تجد في أعلى يمين الشاشة طريقة اختيار اللغة ، يمكنك أن تختار بين اللغة العربية و اللغة الانجليزية'
        ) : speakTextEnglish('To use the application'
        '1- If you want text, please say letters'
        '2- If you want to know a person, please say Human'
        '3- If you want to know the time, please say Time'
        '4- If you want to know the date, please say history'
        '5- If you want to know the things around you from Please say object'
        '6- If you want to know the color, please say color.'
        'We are always with you. We are your eyes.'
    ) ;

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
          child: Card(
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: backgroundColor,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/QA.png',

                width: MediaQuery.of(context).size.width*0.8,
                height: MediaQuery.of(context).size.height*0.48,

              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.14,
              ),

              widget.isArabic==false ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record,
                        size: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text('How to take pictures:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0,top: 10,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fiber_manual_record_outlined,
                        size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text('After entering the application, you can click anywhere on the screen to take a picture and hear the words in the picture.',
                            style: TextStyle(
                              fontSize: 14,

                              color: Colors.grey
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                     height: MediaQuery.of(context).size.height*0.05,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record,
                          size: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text('How do you change the language:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0,top: 10,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fiber_manual_record_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text('After entering the application, you can find at the top right of the screen how to choose the language. You can choose between Arabic and English.',
                            style: TextStyle(
                                fontSize: 14,

                                color: Colors.grey
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record,
                          size: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text('How to deal with things recognition:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0,top: 10,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.fiber_manual_record_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.02,
                        ),
                        const Expanded(
                          child: Text( '1- If you want text, please say letters\n'
                              '2- If you want to know a person, please say Human\n'
                              '3- If you want to know the time, please say Time\n'
                              '4- If you want to know the date, please say history\n'
                              '5- If you want to know the things around you from Please say object\n'
                              '6- If you want to know the color, please say color.',
                            style: TextStyle(
                                fontSize: 14,

                                color: Colors.grey
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),
                ],
              ): Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record,
                          size: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.02,
                          ),
                          const Expanded(
                            child: Text('كيف تقوم بإلتقاط الصور :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 30.0,top: 10,left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.fiber_manual_record_outlined,
                          size: 14,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.02,
                          ),
                          const Expanded(
                            child: Text('يمكنك بعد الدخول على التطبيق أن تضغط على أي مكان في الشاشه لألتقاط صورة وسماع الكلمات الموجودة في الصورة.',
                              style: TextStyle(
                                fontSize: 14,

                                color: Colors.grey
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                       height: MediaQuery.of(context).size.height*0.05,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.fiber_manual_record,
                            size: 16,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.02,
                          ),
                          const Expanded(
                            child: Text('كيف تقوم بتغيير اللغة داخل التطبيق:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 30.0,top: 10,left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.fiber_manual_record_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.02,
                          ),
                          const Expanded(
                            child: Text('يمكنك بعد الدخول على التطبيق أن تجد في أعلى يمين الشاشة طريقة اختيار اللغة ، يمكنك ان تختار بين اللغة العربية و اللغة الانجليزية.',
                              style: TextStyle(
                                  fontSize: 14,

                                  color: Colors.grey
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20,),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
