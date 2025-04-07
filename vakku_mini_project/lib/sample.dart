import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vakku_mini_project/services/firebase_services.dart';
import 'package:vakku_mini_project/services/recordAudio.dart';
import 'profile.dart';

class CharacterScreen extends StatefulWidget {
  final String letter;
  CharacterScreen({required this.letter});

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
    }

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  void playCharacterAudio() async {
    // Implement your audio playing logic here
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FF01E),
              Color(0xFF4FF01E),
              Color(0xFF4FF01E),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarBackgroundPainter(),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconButton(
                          Icons.arrow_back,
                          () => Navigator.pop(context),
                        ),
                        _buildIconButton(
                          null,
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen())),
                          image: 'assets/images/profile.png',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _bounceAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, -_bounceAnimation.value),
                                child: child,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.orangeAccent,
                                  width: 6,
                                ),
                              ),
                              child: Text(
                                widget.letter,
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                  shadows: [
                                    Shadow(
                                      color: Colors.yellow,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.yellow.shade100
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/character.png',
                                width: 180,
                                height: 180,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedActionButton(
                          icon: 'assets/images/mic.png',
                          label: 'RECORD',
                          color: Colors.redAccent,
                          onTap: () => showAudioRecorderDialog(context),
                          size: 90,
                        ),
                        SizedBox(width: 30),
                        AnimatedActionButton(
                          icon: 'assets/images/speaker.png',
                          label: 'LISTEN',
                          color: Colors.blueAccent,
                          isActive: isPlaying,
                          onTap: isPlaying ? null : playCharacterAudio,
                          size: 90,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData? icon, VoidCallback onPressed,
      {String? image}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(
        icon: image != null
            ? Image.asset(image, width: 30, height: 30)
            : Icon(icon, size: 30, color: Colors.purple),
        onPressed: onPressed,
      ),
    );
  }
}

class AnimatedActionButton extends StatefulWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isActive;
  final double size;

  const AnimatedActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isActive = false,
    this.size = 80,
  });

  @override
  _AnimatedActionButtonState createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Column(
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  widget.icon,
                  width: widget.size * 0.5,
                  height: widget.size * 0.5,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.3);
    final random = Random();

    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
