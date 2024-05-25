import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUploadScreen extends StatelessWidget {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('data');

  Future<void> uploadData() async {
    try {
      Map<dynamic, dynamic> data = {
        'name': 'John Doe',
        'age': 30,
        'location': 'New York',
      };

      // رفع البيانات إلى Firebase Realtime Database
      await _databaseReference.set(data);

      print('Data uploaded successfully!');
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Upload'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadData,
          child: Text('Upload Data to Firebase'),
        ),
      ),
    );
  }
}