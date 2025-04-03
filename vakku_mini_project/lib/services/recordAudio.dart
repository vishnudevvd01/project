import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:html' as html; // For web

void showAudioRecorderDialog(BuildContext context) {
  final FlutterSoundRecord recorder = FlutterSoundRecord();
  String? recordedFilePath;
  Uint8List? webRecordedBytes;
  bool isRecording = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Record Audio"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!isRecording) {
                      // Request microphone permission
                      if (!kIsWeb) {
                        var micStatus = await Permission.microphone.request();
                        if (!micStatus.isGranted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Microphone permission required")),
                          );
                          return;
                        }
                      }

                      // Start recording

                      await recorder.start();

                      setState(() => isRecording = true);
                    } else {
                      // Stop recording

                      recordedFilePath = await recorder.stop();

                      setState(() => isRecording = false);
                    }
                  },
                  child:
                      Text(isRecording ? "Stop Recording" : "Start Recording"),
                ),
                const SizedBox(height: 10),
                if (!kIsWeb && recordedFilePath != null)
                  ElevatedButton(
                    onPressed: () {
                      // Play recording on mobile
                      recorder.start(path: recordedFilePath!);
                    },
                    child: const Text("Play Recording"),
                  ),
                if (kIsWeb && recordedFilePath != null)
                  ElevatedButton(
                    onPressed: () {
                      final AudioPlayer _audioPlayer = AudioPlayer();

                      _audioPlayer.play(recordedFilePath!, isLocal: true);

                      // final blob = html.Blob([webRecordedBytes!], 'audio/webm');
                      // final url = html.Url.createObjectUrlFromBlob(blob);
                      // html.AnchorElement(href: url)
                      //   ..setAttribute("download", "recording.webm")
                      //   ..click();
                      // html.Url.revokeObjectUrl(url);
                    },
                    child: const Text("Download Recording"),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    },
  );
}
