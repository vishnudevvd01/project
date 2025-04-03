import 'package:flutter/material.dart';
import 'package:vakku_mini_project/profile.dart';
// import 'package:vakku_mini_project/record_screen.dart';
import 'package:vakku_mini_project/sample.dart';

class MalayalamLettersScreen extends StatelessWidget {
  final List<String> letters = [
    "ക",
    "ഖ",
    "ഗ",
    "ഘ",
    "ങ",
    "ച",
    "ഛ",
    " ജ",
    "ഝ",
    "ഞ",
    "ട",
    "ഠ",
    "ഡ",
    "ഢ",
    "ണ",
    "ത",
    "ഥ",
    "ദ",
    "ധ",
    "ന",
    "പ",
    "ഫ",
    "ബ",
    "ഭ",
    "മ",
    "യ",
    "ര",
    "ല",
    "വ",
    "ശ",
    "ഷ",
    "സ",
    "ഹ",
    "ള",
    "ഴ",
    "റ"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 127, 226, 14),
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CharacterScreen(
                          letter: letters[index],
                        )),
              ),
              child: Text(
                letters[index],
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            );
          },
        ),
      ),
    );
  }
}
