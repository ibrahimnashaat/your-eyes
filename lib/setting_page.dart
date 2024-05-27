import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/shared_preferences.dart';

import 'help.dart'; // قم بتعديل المسار بناءً على مسار ألوانك

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isArabic = cachHelper.getData(key: 'lang')== 'ar'?true: false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          _isArabic ? 'الإعدادات' : 'Settings',
          style: TextStyle(color: Colors.white),
        ),

      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              _isArabic ? 'إعدادات اللغة:' : 'Language Settings : ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _isArabic ? 'اختر اللغة: ' : 'Select Language: ',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                Spacer(),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _isArabic ? 'Arabic' : 'English',
                  icon: Icon(Icons.language, color: backgroundColor),
                  onChanged: (String? newValue) {
                    setState(() {
                      _isArabic = newValue == 'Arabic';
                      cachHelper.saveData(key: 'lang', value: _isArabic?'ar':'en');
                      _isArabic
                          ? speakTextArabic('أنت الأن تتفاعل باللغة العربية')
                          : speakTextEnglish('You are now interacting using English');

                      // cachHelper.putBoolean(key: 'isArabic', value: _isArabic);
                    });
                  },
                  underline: Container(
                    height: 1,
                    color: backgroundColor,
                  ),
                  items: <String>['Arabic', 'English']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: backgroundColor),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 30),
            Divider(color: Colors.black26),
            SizedBox(height: 20),
            Text(
              _isArabic ? 'مساعدة' : 'Help',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: backgroundColor,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help(isArabic: _isArabic)),
                  );
                },
                icon: Icon(Icons.help_outline, color: Colors.white),
                label: Text(
                  _isArabic ? 'اذهب إلى المساعدة' : 'Go to Help',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: backgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}