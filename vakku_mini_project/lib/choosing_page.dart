import 'package:flutter/material.dart';
import 'package:vakku_mini_project/swaraksharangal.dart';
import 'package:vakku_mini_project/profile.dart';
import 'package:vakku_mini_project/venjanaksharangal.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA8EB7B),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 91),
                  Expanded(
                    child: MenuButton(
                      imagePath: "assets/images/aa.png",
                      label: "സ്വരാക്ഷരങ്ങൾ",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => HomeScreen1(),
                        ));
                      },
                    ),
                  ),
                  SizedBox(height: 43),
                  Expanded(
                    child: MenuButton(
                      imagePath: "assets/images/kaa.png",
                      label: "വ്യഞ്ജനാക്ഷരങ്ങൾ",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => MalayalamLettersScreen(),
                        ));
                      },
                    ),
                  ),
                  SizedBox(height: 43),
                  Expanded(
                    child: MenuButton(
                      imagePath: "assets/images/va.png",
                      label: "വാക്കുകൾ",
                      onPressed: () {
                        // for further enhancement
                      },
                    ),
                  ),
                  SizedBox(height: 76),
                ],
              ),
            ),

            Positioned(
              top: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4CD30B),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      color: Color(0xff105B21),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.person, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MenuButton widget definition
class MenuButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  MenuButton(
      {required this.imagePath, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              color: Color(0xff105B21),
              blurRadius: 3,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CD30B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.black26,
            elevation: 5,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 90,
                width: 90,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
