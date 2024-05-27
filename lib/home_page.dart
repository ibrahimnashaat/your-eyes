import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_eyes/color_detection/color_detection.dart';
import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/date_detection/date_detection.dart';
import 'package:your_eyes/every_object_help.dart';
import 'package:your_eyes/face_detection/face_detection.dart';
import 'package:your_eyes/help.dart';
import 'package:your_eyes/object_detection/object_detection.dart';
import 'package:your_eyes/shared_preferences.dart';
import 'package:your_eyes/text_detection/text_detection.dart';
import 'package:your_eyes/time_detection/time_detection.dart';
import 'package:speech_to_text/speech_to_text.dart'as stt;


import 'faq.dart';

class HomePage extends StatefulWidget {



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> texts = ['Hey!', 'Welcome back'];

  List<bool> visible = [false, false];

  bool _isVisible = true;

  bool _isPermissionGranted = false;


  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;

    cachHelper.saveData(key: 'cameraIsOpen', value: _isPermissionGranted);
    setState(() {});
  }


  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Initializing...';
  double _confidence = 1.0;
  void _listenContinuously() async {
    bool available = await _speech.initialize(
      onStatus: (val) => _statusListener(val),
      // onError: (val) => _errorListener(val),
    );

    if (available) {
      _startListening();
    } else {
      setState(() {
        _isListening = false;
        _text = "Speech recognition not available on this device";
      });
    }
  }

  void _startListening() {
    setState(() => _isListening = true);
    _speech.listen(
      onResult: (val) => setState(() {
        _text = val.recognizedWords;
        print(_text);
        if (val.hasConfidenceRating && val.confidence > 0) {
          _confidence = val.confidence;
        }
        _navigateBasedOnCommand(_text);

      }),
      localeId: 'en_US',
    );
  }




  void _statusListener(String status) {
    if (status == 'done' || status == 'notListening') {
      _startListening();
    }
  }





  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();
    _listenContinuously();

    // _requestCameraPermission();
    _animateText();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }


  void  _navigateBasedOnCommand(String command) {
    switch (command) {
      case 'letters':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> TextDetection()));
        break;
      case 'object':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ObjectDetection()));
        break;
      case 'colour':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ColorDetection()));
        break;
      case 'time':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> TimeDetection()));
        break;
      case 'the date':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> DateDetection()));
        break;
      case 'history':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> DateDetection()));
        break;
      case 'human':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> FaceDetection()));
        break;
      case 'help me':
        Navigator.push(context,MaterialPageRoute(builder: (context)=> Help(isArabic: cachHelper.getData(key: 'lang') == 'ar' ? true : false,)));
        break;
      default:
        break;
    }
  }


  @override
  void dispose() {
    // Reset to default style when leaving this page
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }


  void _animateText() {
    for (int i = 0; i < texts.length; i++) {
      Future.delayed(Duration(milliseconds: i * 1000), () {
        setState(() {
          visible[i] = true;
        });
      });
    }
  }


  List<Map<String,dynamic>> detectionObjects = [
    {
      'image':'https://th.bing.com/th/id/OIG1.6rHuFlQcYJUduELV.GOt?pid=ImgGn',
      'name':'Text',
      'page':TextDetection()
    },
    {
      'image':'https://th.bing.com/th/id/OIG1.4wksttcGR9kS.B4ffCQB?w=1024&h=1024&rs=1&pid=ImgDetMain',
      'name':'Object',
      'page':ObjectDetection()
    },
    {
      'image':'https://th.bing.com/th/id/OIG2.TzwVJTpZpO7Fg.n80LSZ?pid=ImgGn',
      'name':'Face',
      'page':FaceDetection()
    },
    {
      'image':'https://th.bing.com/th/id/OIG2.cL7n69sKS2FiMIwCoi1H?pid=ImgGn',
      'name':'Date',
      'page':DateDetection()
    },
    {
      'image':'https://th.bing.com/th/id/OIG2.0RQmuse14gwk6j0ftTXc?w=270&h=270&c=6&r=0&o=5&pid=ImgGn',
      'name':'Time',
      'page':TimeDetection()
    },
    {
      'image':'https://th.bing.com/th/id/OIG1.wAc.dTGo53XZvi7soXxq?w=270&h=270&c=6&r=0&o=5&pid=ImgGn',
      'name':'Color',
      'page':ColorDetection()
    },
  ];
  List<Map<String,dynamic>> detectionObjectsHelp = [
    {
      'image':'https://th.bing.com/th/id/OIG4.rjgafjW1HQc60f09u4_l?pid=ImgGn',
      'name':'Text',
      'page':TextDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على النصوص ، يجب ان تقول بصوت واضح التعرف على النصوص، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة نص',
      'descriptionEN':'If you are having trouble accessing the text recognition feature, you must say in a clear voice, “Text recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “Text.”'
    },
    {
      'image':'https://th.bing.com/th/id/OIG4.H5MT7TNIyV_K9aH_uZgN?pid=ImgGn',
      'name':'Object',
      'page':ObjectDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على الاشياء ، يجب ان تقول بصوت واضح التعرف على الاشياء، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة شيء',
      'descriptionEN':'If you are having trouble accessing the object recognition feature, you must say in a clear voice, “object recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “object.”'

    },
    {
      'image':'https://th.bing.com/th/id/OIG3.iK2nummL8BQF2Dqq4AGo?pid=ImgGn',
      'name':'Face',
      'page':FaceDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على الوجه ، يجب ان تقول بصوت واضح التعرف على الوجه، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة وجه',
      'descriptionEN':'If you are having trouble accessing the face recognition feature, you must say in a clear voice, “face recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “face.”'

    },
    {
      'image':'https://th.bing.com/th/id/OIG2.NkPIo84KS3aXosNgUWF0?pid=ImgGn',
      'name':'Date',
      'page':DateDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على التاريخ ، يجب ان تقول بصوت واضح التعرف على التاريخ، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة التاريخ',
      'descriptionEN':'If you are having trouble accessing the date recognition feature, you must say in a clear voice, “date recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “date.”'

    },
    {
      'image':'https://th.bing.com/th/id/OIG4.O1b4GQdWmq6g0kavmruo?pid=ImgGn',
      'name':'Time',
      'page':TimeDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على الوقت ، يجب ان تقول بصوت واضح التعرف على الوقت، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة الوقت',
      'descriptionEN':'If you are having trouble accessing the time recognition feature, you must say in a clear voice, “time recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “time.”'

    },
    {
      'image':'https://th.bing.com/th/id/OIG3.Z_9aojqh94e45sxr2GkN?w=1024&h=1024&rs=1&pid=ImgDetMain',
      'name':'Color',
      'page':ColorDetection(),
      'descriptionAR':'اذا كنت تواجه مشكله في الوصول الى ميزة التعرف على الالوان ، يجب ان تقول بصوت واضح التعرف على الالوان، واذا كنت تريد ان تجدها بنفسك فهي توجد في الصفحة الرئيسية ويوجد أسفل منها كلمة لون',
      'descriptionEN':'If you are having trouble accessing the color recognition feature, you must say in a clear voice, “color recognition” and if you want to find it yourself, it is located on the home page, and below it is the word “color.”'

    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatesAndFAQ()));
                    }, icon: Icon(
                      Icons.info_outline_rounded,
                      size: 30,
                      color: backgroundColor,
                    )),
                    Spacer(),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: backgroundColor,
                      backgroundImage: NetworkImage('https://th.bing.com/th/id/OIG4.Z27wrP259NfGMikMueYY?w=270&h=270&c=6&r=0&o=5&pid=ImgGn'),
                    ),
                  ],
                ),
              ),





              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(texts.length * 2 - 1, (index) {
                    if (index.isEven) {
                      int textIndex = index ~/ 2;
                      return AnimatedOpacity(
                        opacity: visible[textIndex] ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          texts[textIndex],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: backgroundColor,
                            letterSpacing: 1,
                            wordSpacing: 1,
                            height: 0.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return SizedBox(height: 30); // التحكم في المسافة بين النصوص
                    }
                  }),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
              ),

             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Row(
                 children: [
                   AnimatedOpacity(
                     opacity: _isVisible ? 1.0 : 0.0,
                     duration: Duration(milliseconds: 500),
                     child: Container(
                       width: 15,
                       height: 15,
                       decoration: BoxDecoration(
                         color: backgroundColor,
                         shape: BoxShape.circle,
                       ),
                     ),
                   ),
                   SizedBox(
                     width: 10,
                   ),
                   Text('Detection',
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.w700,
                       color: backgroundColor,

                     ),
                   ),
                 ],
               ),
             ),

                 SizedBox(
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*0.2,
                   child: Padding(
                     padding: const EdgeInsets.only(left: 10),
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       shrinkWrap: true,
                       itemBuilder: (context,index){
                       return detection(
                           detectionObjects[index]['image'],
                           detectionObjects[index]['name'],
                         detectionObjects[index]['page']
                       );
                     },
                     itemCount: detectionObjects.length,
                     ),
                   ),
                 ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.02,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Read',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: backgroundColor,

                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.25,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return help(
                          detectionObjectsHelp[index]['image'],
                        detectionObjectsHelp[index]['name'],
                        detectionObjectsHelp[index]['descriptionAR'],
                        detectionObjectsHelp[index]['descriptionEN'],
                        detectionObjectsHelp[index]['page'],

                      );
                    },
                    itemCount: detectionObjectsHelp.length,
                  ),
                ),
              ),


              SizedBox(
                height: MediaQuery.of(context).size.height*0.02,
              ),

            ],
          ),
        ),
      )
    );
  }



  detection (
      image,
      name,
      page
      ){
   return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            height: MediaQuery.of(context).size.height*0.15,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white,
                child: Image.network(image),

              ),
            ),
          ),
          Text(name,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: backgroundColor,

            ),
          ),
        ],
      ),
    );
  }

  help(
      image,
      name,
      descriptionAR,
               descriptionEN,
      page,

      ){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: SizedBox(

        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.23,

        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: backgroundColor,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: Image.network(image,

                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.height*0.25,

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How can you activate the $name recognition feature?',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,

                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EveryObjectHelp(
                          image: image,
                          descriptionAR: descriptionAR,
                          descriptionEN: descriptionEN,
                          name: name,
                          page: page)
                      ));
                    }, child: Text('View More',style: TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.w600
                    ),))
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
