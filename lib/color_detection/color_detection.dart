import 'dart:io';
import 'package:camera/camera.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_eyes/help.dart';
import 'package:your_eyes/shared_preferences.dart';
import 'package:palette_generator/palette_generator.dart';

import '../constants/colors.dart';


class ColorDetection extends StatefulWidget {
  @override
  _ColorDetectionState createState() => _ColorDetectionState();
}

class _ColorDetectionState extends State<ColorDetection> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeak = false;

  Future<void> speakTextEnglish(String text) async {
    setState(() {
      isSpeak = true;
    });
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
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
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1);
    isSpeak = true;
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeak = false;
      });
    });
  }

  bool _isPermissionGranted = cachHelper.getData(key: 'cameraIsOpen')??false;
  bool _isArabic = cachHelper.getData(key: 'lang')== 'ar'?true: false;
  bool isLoading = true;

  CameraController? _cameraController;
  Set<String> detectedColorsSet = {};

  @override
  void initState() {
    super.initState();
    _isArabic = cachHelper.getData(key: 'lang') == 'ar'?true: false;
    // _isArabic == true
    //     ? speakTextArabic('انت الأن تتفاعل باللغة العربية')
    //     : speakTextEnglish('You are now interacting using English');

    speakTextEnglish('Welcome to color recognition');
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
          _scanButton(),
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

  Widget _scanButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: InkWell(
          onTap: _scanImage,
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

  Future<void> _scanImage() async {
    if (isSpeak) {
      flutterTts.stop();
      isSpeak = false;
    } else {
      if (_cameraController == null || !_cameraController!.value.isInitialized) return;
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ).whenComplete(() => setState(() {
        isLoading = false;
      }));

      try {
        var pictureFile = await _cameraController!.takePicture();
        File file = File(pictureFile.path);
        final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(FileImage(file));
        String detectedColors = 'Detected Colors:\n';

        int colorsCount = 0;  // متغير لتتبع عدد الألوان المكتشفة

        for (Color color in paletteGenerator.colors) {
          if (colorsCount >= 3) {
            break;  // إيقاف الحلقة بعد اكتشاف 3 ألوان
          }

          String colorName = ColorNames.guess(color);

          if (!detectedColorsSet.contains(colorName)) {
            detectedColorsSet.add(colorName);
            detectedColors += '$colorName\n';
            print("تم اكتشاف اللون: $colorName");
            colorsCount++;  // زيادة العداد بعد اكتشاف لون جديد
          }
        }

        if (detectedColorsSet.isEmpty) {
          detectedColors = _isArabic ? 'لم يتم الكشف عن أي ألوان' : 'No colors detected';
        }

        if (_isArabic) {
          await speakTextArabic(detectedColors);
        } else {
          await speakTextEnglish(detectedColors);
        }

        if (isLoading) {
          Navigator.pop(context);
        }
      } catch (e) {
        Navigator.of(context).pop();
        print('Error: $e');
      }
    }
  }
}