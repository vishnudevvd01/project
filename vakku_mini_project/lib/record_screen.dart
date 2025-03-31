import 'package:flutter/material.dart';
import 'package:vakku_mini_project/profile.dart';

class CharacterScreen extends StatelessWidget {
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
                CircleButton(imagePath: 'assets/images/mic.png'),
                CircleButton(imagePath: 'assets/images/speaker.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String imagePath;

  CircleButton({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.green,
        child: InkWell(
          onTap: () {},
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
