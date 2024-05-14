import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_eyes/help.dart';
import 'package:your_eyes/shared_preferences.dart';

import 'constants/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> speakTextEnglish(String text) async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }


  Future<void> speakTextArabic(String text) async {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar-SA'); // تعيين اللغة العربية
    await flutterTts.setSpeechRate(0.5); // تعيين معدل النطق
    await flutterTts.setPitch(1); // تعيين المد
    await flutterTts.speak(text);
  }


  bool _isPermissionGranted = false;
  bool _isArabic = false;

  bool isLoading = true;

  CameraController? _cameraController;

  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();

    _isArabic = cachHelper.getBoolean(key: 'isArabic')??false;
    _isArabic == true ? speakTextArabic('انت الأن تتفاعل باللغة العربية') : speakTextEnglish('You are now interacting using English');

    _requestCameraPermission();
  }

  @override
  void dispose() {
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,

        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Help(isArabic: _isArabic,)));
          },
          icon: const Icon(
            Icons.help_outline,
            color: Colors.white,
          ),
        ),

        actions: [
          DropdownButton<String>(
            dropdownColor: backgroundColor,
            value: _isArabic ? 'Arabic' : 'English',
            icon: Icon(Icons.language, color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                _isArabic = newValue == 'Arabic';
                _isArabic == true ? speakTextArabic('أنت الأن تتفاعل باللغة العربية') : speakTextEnglish('You are now interacting using English');
                cachHelper.putBoolean(key: 'isArabic',value: _isArabic);
              });
            },
            underline: Container(
              height: 1,
              color: Colors.white,
            ),


            items: <String>['Arabic', 'English']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                style: const TextStyle(
                  color: Colors.white
                ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: _isPermissionGranted
          ? Stack(
                  children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
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
        if (snapshot.hasData) {
          _initCameraController(snapshot.data!);
          return CameraPreview(_cameraController!);
        } else {
          return Container();
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
          onTap:_scanImage,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
    if (_cameraController != null) {
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

      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);

      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    if (!isLoading){
      isLoading = true;
    }

    // Show a loading dialog while processing
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ).whenComplete(() => setState((){
      isLoading = false;

    }));

    try {
      var pictureFile = await _cameraController!.takePicture();
      File? file = File(pictureFile.path);
      var inputImage = InputImage.fromFile(file);

      String recognizedText = '';

      if (_isArabic) {
        recognizedText = await FlutterTesseractOcr.extractText(inputImage.filePath??file.path, language: 'ara');
        await speakTextArabic(recognizedText);
      }
      else {
        final recognisedTextInstance = await textRecognizer.processImage(inputImage);
        recognizedText = recognisedTextInstance.text;
        await speakTextEnglish(recognizedText);
      }

      /// Close the loading dialog after completion

      isLoading == true   ? Navigator.pop(context) : null ;

    } catch (e) {

      Navigator.of(context).pop();
      print('Error: $e');
    }
  }





}






