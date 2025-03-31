import 'package:flutter/material.dart';
import 'package:vakku_mini_project/profile.dart';
import 'package:vakku_mini_project/record_screen.dart';
// import 'package:vakku_mini_project/record_screen.dart';
// import 'package:vakku_mini_project/sample.dart';

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 123, 203, 33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/profile.png', width: 40),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              'അ',
              'ആ',
              'ഇ',
              'ഈ',
              'ഉ',
              'ഊ',
              'ജ',
              'എ',
              'ഏ',
              'ഐ',
              'ഒ',
              'ഓ',
              'ഔ',
              'അം',
              'അഃ'
            ].map((text) => _buildButton(context, text)).toList(),
          ),
          const SizedBox(height: 40),
          Image.asset('assets/images/character.png', height: 200),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CharacterScreen()));
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}

class ProfileScreen1 extends StatelessWidget {
  const ProfileScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page')),
    );
  }
}

class KeyScreen extends StatelessWidget {
  const KeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keys Page')),
      body: const Center(child: Text('Keys Page')),
    );
  }
}
