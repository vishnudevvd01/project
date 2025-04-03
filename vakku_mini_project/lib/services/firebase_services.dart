import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getAudioUrl(String letter) async {
    try {
      String url = "";
      await _firestore
          .collection('Malayalam_alphabets')
          .doc(letter)
          .get()
          .then((value) {
        if (value.exists) {
          url = value.get("audio_url");
          print(url);
        }
      });
      return url;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching audio URL: $e");
      }
      return "";
    }
  }
}
