import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
// Import your Firebase service
import 'package:vakku_mini_project/services/firebase_services.dart';
import 'package:vakku_mini_project/services/recordAudio.dart';
import 'profile.dart';

class CharacterScreen extends StatefulWidget {
  String letter;
  CharacterScreen({required this.letter});
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play audio for the character
  void playCharacterAudio() async {
    String audioUrl = await _firebaseService.getAudioUrl(
        widget.letter); // Replace with your actual character/letter ID
    if (audioUrl.isNotEmpty) {
      await _audioPlayer
          .play(audioUrl); // Play audio from the URL
    } else {
      print("Audio not available for this character.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5ACD05),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Image.asset('assets/images/profile.png'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/character.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleButton(
                    imagePath: 'assets/images/mic.png',
                    onTap: () {
                      showAudioRecorderDialog(context);
                      // You can add recording functionality here later
                    }),
                CircleButton(
                    imagePath: 'assets/images/speaker.png',
                    onTap: () {
                      playCharacterAudio(); // Play audio when the speaker button is pressed
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UrlSource {
  UrlSource(String audioUrl);
}

class CircleButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  CircleButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.green,
        child: InkWell(
          onTap: onTap, // Trigger the onTap action passed to the button
          child: SizedBox(
            width: 70,
            height: 70,
            child: Center(
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
