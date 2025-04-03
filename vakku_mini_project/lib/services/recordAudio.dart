// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// // This is a concrete widget class - not abstract
// class AudioRecorderDialog extends StatefulWidget {
//   final Function(String)? onAudioSaved;

//   const AudioRecorderDialog({Key? key, this.onAudioSaved}) : super(key: key);

//   @override
//   _AudioRecorderDialogState createState() => _AudioRecorderDialogState();
// }

// class _AudioRecorderDialogState extends State<AudioRecorderDialog> {
//   // Using concrete implementations of the recorder and player
//   late final AudioRecorder _audioRecorder;
//   late final AudioPlayer _audioPlayer;
  
//   String? _recordedFilePath;
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   Duration _recordDuration = Duration.zero;
//   Duration _playbackPosition = Duration.zero;
//   Duration _playbackDuration = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize concrete implementations
//     _audioRecorder = AudioRecorder();
//     _audioPlayer = AudioPlayer();
    
//     _checkPermissions();
    
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         // Correct PlayerState reference
//         _isPlaying = state == PlayerState.playing;
//       });
//       if (state == PlayerState.completed) {
//         setState(() {
//           _playbackPosition = Duration.zero;
//         });
//       }
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       setState(() {
//         _playbackPosition = position;
//       });
//     });

//     _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() {
//         _playbackDuration = duration;
//       });
//     });
//   }

//   Future<void> _checkPermissions() async {
//     final hasPermission = await _audioRecorder.hasPermission();
//     if (!hasPermission) {
//       // Handle permission issue
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Microphone permission not granted')),
//         );
//         Navigator.of(context).pop();
//       }
//     }
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         // Get the temporary directory
//         final tempDir = await getTemporaryDirectory();
//         final filePath = '${tempDir.path}/audio_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
//         // Configure recording options
//         final recordConfig = const RecordConfig(
//           encoder: AudioEncoder.aacLc,
//           bitRate: 128000,
//           sampleRate: 44100,
//         );
        
//         // Start recording with the specified configuration
//         await _audioRecorder.start(recordConfig, path: filePath);
        
//         setState(() {
//           _isRecording = true;
//           _recordDuration = Duration.zero;
//           _recordedFilePath = filePath;
//         });
        
//         // Start timer to track recording duration
//         const tick = Duration(seconds: 1);
//         Future.delayed(tick, _updateRecordDuration);
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   void _updateRecordDuration() {
//     if (_isRecording && mounted) {
//       setState(() {
//         _recordDuration = _recordDuration + const Duration(seconds: 1);
//       });
//       Future.delayed(const Duration(seconds: 1), _updateRecordDuration);
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       final path = await _audioRecorder.stop();
//       if (mounted) {
//         setState(() {
//           _isRecording = false;
//           if (path != null) {
//             _recordedFilePath = path;
//           }
//         });
        
//         if (widget.onAudioSaved != null && path != null) {
//           widget.onAudioSaved!(path);
//         }
//       }
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordedFilePath != null) {
//       try {
//         if (_isPlaying) {
//           await _audioPlayer.pause();
//         } else {
//           // Use the file path directly with newer audioplayers versions
//           // or wrap it with a Source object for older versions
//           await _audioPlayer.play(('file://${_recordedFilePath!}'));
//           // Alternative for newer versions:
//           // await _audioPlayer.setSource(DeviceFileSource(_recordedFilePath!));
//           // await _audioPlayer.resume();
//         }
//       } catch (e) {
//         debugPrint('Error playing recording: $e');
//       }
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   void dispose() {
//     _audioRecorder.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Audio Recorder'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (_isRecording)
//               Text(
//                 'Recording: ${_formatDuration(_recordDuration)}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             if (_recordedFilePath != null && !_isRecording)
//               Column(
//                 children: [
//                   const Text('Recorded Audio:'),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(_formatDuration(_playbackPosition)),
//                       Expanded(
//                         child: Slider(
//                           value: _playbackPosition.inSeconds.toDouble(),
//                           max: _playbackDuration.inSeconds.toDouble() > 0 ? 
//                                 _playbackDuration.inSeconds.toDouble() : 1.0,
//                           onChanged: (value) async {
//                             final position = Duration(seconds: value.toInt());
//                             await _audioPlayer.seek(position);
//                             setState(() {
//                               _playbackPosition = position;
//                             });
//                           },
//                         ),
//                       ),
//                       Text(_formatDuration(_playbackDuration)),
//                     ],
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 if (_isRecording)
//                   IconButton(
//                     icon: const Icon(Icons.stop, color: Colors.red, size: 36),
//                     onPressed: _stopRecording,
//                   )
//                 else
//                   IconButton(
//                     icon: const Icon(Icons.mic, color: Colors.blue, size: 36),
//                     onPressed: _startRecording,
//                   ),
//                 if (_recordedFilePath != null && !_isRecording)
//                   IconButton(
//                     icon: Icon(
//                       _isPlaying ? Icons.pause : Icons.play_arrow,
//                       color: Colors.green,
//                       size: 36,
//                     ),
//                     onPressed: _playRecording,
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           child: const Text('Cancel'),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         if (_recordedFilePath != null && !_isRecording)
//           TextButton(
//             child: const Text('Save'),
//             onPressed: () {
//               if (_recordedFilePath != null) {
//                 Navigator.of(context).pop(_recordedFilePath);
//               }
//             },
//           ),
//       ],
//     );
//   }
// }

// // This is a concrete class that implements the recording functionality
// class AudioRecorder {
//   final _recorder = Record();
  
//   Future<bool> hasPermission() async {
//     return await _recorder.hasPermission();
//   }
  
//   Future<void> start(RecordConfig config, {required String path}) async {
//     await _recorder.start(
//       path: path,
//       encoder: config.encoder,
//       bitRate: config.bitRate,
//       sampleRate: config.sampleRate,
//     );
//   }
  
//   Future<String?> stop() async {
//     return await _recorder.stop();
//   }
  
//   void dispose() {
//     _recorder.dispose();
//   }
// }

// // Configuration class for audio recording
// class RecordConfig {
//   final AudioEncoder encoder;
//   final int bitRate;
//   final int sampleRate;
  
//   const RecordConfig({
//     this.encoder = AudioEncoder.aacLc,
//     this.bitRate = 128000,
//     this.sampleRate = 44100,
//   });
// }

// // Function to show the audio recorder dialog
// Future<String?> showAudioRecorderDialog(BuildContext context) async {
//   return await showDialog<String>(
//     context: context,
//     builder: (context) => const AudioRecorderDialog(),
//   );
// }

// // Example usage:
// void showRecordingDialog(BuildContext context) async {
//   final audioPath = await showAudioRecorderDialog(context);
//   if (audioPath != null) {
//     // Do something with the recorded audio path
//     debugPrint('Recorded audio saved at: $audioPath');
//   }
// }