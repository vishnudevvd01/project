import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getAudioUrl(String letter) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Malayalam_alphabets').doc(letter).get();
      return doc['gs://vaaku-audio.firebasestorage.app/malayalam_audios/അ.mp3'];
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching audio URL: $e");
      }
      return "";
    }
  }
}
