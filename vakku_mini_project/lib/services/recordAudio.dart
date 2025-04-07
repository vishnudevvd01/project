import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

// Create a global recorder instance
final FlutterSoundRecord _recorder = FlutterSoundRecord();

void showAudioRecorderDialog(BuildContext context) {
  bool isRecording = false;
  String? recordedFilePath;
  int recordingDuration = 0;
  Timer? timer;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Record your pronunciation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Recording timer display
              if (isRecording)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${recordingDuration}s",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              
              // Recording animation
              if (isRecording)
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              
              // Record button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecording ? Colors.red : Color(0xff5ACD05),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (!await _recorder.hasPermission()) {
                    final status = await Permission.microphone.request();
                    if (!status.isGranted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Microphone permission denied")),
                      );
                      return;
                    }
                  }

                  if (!isRecording) {
                    Directory tempDir = await getTemporaryDirectory();
                    recordedFilePath = '${tempDir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.wav';

                    await _recorder.start(
                      path: recordedFilePath!,
                      bitRate: 16000,
                      samplingRate: 16000,
                    );

                    // Start a timer to show recording duration
                    recordingDuration = 0;
                    timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      setState(() {
                        recordingDuration++;
                      });
                    });

                    setState(() {
                      isRecording = true;
                    });
                  } else {
                    timer?.cancel();
                    await _recorder.stop();
                    setState(() {
                      isRecording = false;
                    });

                    if (recordedFilePath != null) {
                      Navigator.pop(context);
                      sendToServer(context, recordedFilePath!);
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isRecording ? Icons.stop : Icons.mic),
                    SizedBox(width: 8),
                    Text(isRecording ? "Stop Recording" : "Start Recording"),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (isRecording) {
                  timer?.cancel();
                  await _recorder.stop();
                }
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
    },
  );
}

Future<void> sendToServer(BuildContext context, String path) async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xff5ACD05)),
              SizedBox(height: 20),
              Text("Analyzing pronunciation..."),
            ],
          ),
        ),
      ),
    );
    
    // Make sure the file exists
    File audioFile = File(path);
    if (!await audioFile.exists()) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recording file not found")),
      );
      return;
    }
    
    // Check Flask API server reachability
    try {
      final healthCheck = await http.get(Uri.parse("http://127.0.0.1:5000/health"))
          .timeout(Duration(seconds: 5));
      if (healthCheck.statusCode != 200) {
        throw Exception("API server is not responding correctly");
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not connect to the API server. Make sure your Flask API is running.")),
      );
      return;
    }
    
    // Create multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://127.0.0.1:5000/compare"),
    );
    
    // Add both files - using the same file for demo purposes
    // In a real app, you'd have separate reference and user files
    request.files.add(await http.MultipartFile.fromPath('reference', path));
    request.files.add(await http.MultipartFile.fromPath('user', path));

    var response = await request.send().timeout(Duration(seconds: 30));
    var responseBody = await response.stream.bytesToString();
    
    // Close loading dialog
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      // Parse JSON response
      Map<String, dynamic> result = jsonDecode(responseBody);
      double score = result['acoustic_similarity'] ?? 0;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pronunciation Score"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${(score * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold,
                  color: score > 0.7 ? Colors.green : Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text(
                score > 0.7 
                  ? "Great pronunciation!" 
                  : "Keep practicing!",
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  } catch (e) {
    // Make sure loading dialog is closed if an error occurs
    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to analyze audio: $e")),
    );
  }
}