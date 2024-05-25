import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_eyes/help.dart';
import 'package:your_eyes/shared_preferences.dart';
import 'package:intl/intl.dart'; // استيراد مكتبة intl

class DateDetection extends StatefulWidget {
  @override
  _DateDetectionState createState() => _DateDetectionState();
}

class _DateDetectionState extends State<DateDetection> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeak = false;

  Future<void> speakTextEnglish(String text) async {
    setState(() {
      isSpeak = true;
    });
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeak = false;
      });
    });
  }

  Future<void> speakTextArabic(String text) async {
    await flutterTts.setLanguage('ar-SA');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    isSpeak = true;
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeak = false;
      });
    });
  }

  Future<void> speakCurrentDate() async {
    String currentDate = DateFormat.yMMMMEEEEd(_isArabic ? 'ar' : 'en').format(DateTime.now());
    if (_isArabic) {
      await speakTextArabic('اليوم هو $currentDate');
    } else {
      await speakTextEnglish('Today is $currentDate');
    }
  }

  bool _isPermissionGranted = cachHelper.getData(key: 'cameraIsOpen')??false;
  bool _isArabic = cachHelper.getData(key: 'lang')== 'ar'?true: false;
  bool isLoading = true;

  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _isArabic = cachHelper.getData(key: 'lang') == 'ar'?true: false;
    // _isArabic == true
    //     ? speakTextArabic('انت الأن تتفاعل باللغة العربية')
    //     : speakTextEnglish('You are now interacting using English');
    speakTextEnglish('Welcome to date recognition');
    _requestCameraPermission();
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(
      //           builder: (context) => Help(isArabic: _isArabic,)));
      //     },
      //     icon: const Icon(
      //       Icons.help_outline,
      //       color: Colors.white,
      //     ),
      //   ),
      //   actions: [
      //     DropdownButton<String>(
      //       dropdownColor: backgroundColor,
      //       value: _isArabic ? 'Arabic' : 'English',
      //       icon: Icon(Icons.language, color: Colors.white),
      //       onChanged: (String? newValue) {
      //         setState(() {
      //           _isArabic = newValue == 'Arabic';
      //           _isArabic == true ? speakTextArabic(
      //               'أنت الأن تتفاعل باللغة العربية') : speakTextEnglish(
      //               'You are now interacting using English');
      //           cachHelper.putBoolean(key: 'isArabic', value: _isArabic);
      //         });
      //       },
      //       underline: Container(
      //         height: 1,
      //         color: Colors.white,
      //       ),
      //       items: <String>['Arabic', 'English']
      //           .map<DropdownMenuItem<String>>((String value) {
      //         return DropdownMenuItem<String>(
      //           value: value,
      //           child: Text(value,
      //             style: const TextStyle(
      //                 color: Colors.white
      //             ),
      //           ),
      //         );
      //       }).toList(),
      //     ),
      //   ],
      // ),
      body: _isPermissionGranted
          ? Stack(
        children: [
          SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: _cameraPreviewWidget()
          ),
          _dateButton(), // إضافة زر نطق التاريخ
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          _initCameraController(snapshot.data!);
          return CameraPreview(_cameraController!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _dateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: InkWell(
          onTap: speakCurrentDate, // تعيين الوظيفة لنطق التاريخ
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
          ),
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
    setState(() {});
  }

  void _initCameraController(List<CameraDescription> cameras) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraController = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      try {
        await _cameraController!.initialize();
        await _cameraController!.setFlashMode(FlashMode.off);

        if (!mounted) {
          return;
        }
        setState(() {});
      } catch (e) {
        print('Camera initialization error: $e');
      }
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }
}