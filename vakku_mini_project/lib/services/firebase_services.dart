import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getAudioUrl(String letter) async {
    try {
      // Normalize the letter to be used as a document ID
      final String normalizedLetter = letter.trim();
      
      if (normalizedLetter.isEmpty) {
        if (kDebugMode) {
          print("Error: Empty letter provided");
        }
        return "";
      }
      
      final DocumentSnapshot doc = await _firestore
          .collection('Malayalam_alphabets')
          .doc(normalizedLetter)
          .get();
          
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey("audio_url")) {
          final url = data["audio_url"] as String;
          if (kDebugMode) {
            print("Found audio URL for $normalizedLetter: $url");
          }
          return url;
        } else {
          if (kDebugMode) {
            print("Document exists but no audio_url field found for $normalizedLetter");
          }
          return "";
        }
      } else {
        if (kDebugMode) {
          print("No document found for letter: $normalizedLetter");
        }
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching audio URL for $letter: $e");
      }
      return "";
    }
  }
}