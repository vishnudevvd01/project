import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:html' as html; // Only use on web

void showAudioRecorderDialog(BuildContext context) {
  final FlutterSoundRecord recorder = FlutterSoundRecord();
  String? recordedFilePath;
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

                      // Start recording (only works for mobile)
                      if (!kIsWeb) {
                        await recorder.start();
                        setState(() => isRecording = true);
                      }
                    } else {
                      // Stop recording (only for mobile)
                      if (!kIsWeb) {
                        recordedFilePath = await recorder.stop();
                        setState(() => isRecording = false);
                      }
                    }
                  },
                  child:
                      Text(isRecording ? "Stop Recording" : "Start Recording"),
                ),
                const SizedBox(height: 10),

                // Playback for mobile
                if (!kIsWeb && recordedFilePath != null)
                  ElevatedButton(
                    onPressed: () async {
                      final AudioPlayer _audioPlayer = AudioPlayer();
                      await _audioPlayer
                          .play(DeviceFileSource(recordedFilePath!));
                    },
                    child: const Text("Play Recording"),
                  ),

                // Download option for web
                if (kIsWeb && recordedFilePath != null)
                  ElevatedButton(
                    onPressed: () async {
                      final blob = html.Blob([recordedFilePath!]);
                      final url = html.Url.createObjectUrlFromBlob(blob);
                      final anchor = html.AnchorElement(href: url)
                        ..setAttribute("download", "recording.wav")
                        ..click();
                      html.Url.revokeObjectUrl(url);
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
