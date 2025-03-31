import 'package:flutter/material.dart';
import 'package:vakku_mini_project/main.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // background color
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blue[300],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[300],
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name, // name variable
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Joined 27 March 2025',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Profile Options
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  ProfileOption(icon: Icons.edit, title: "Edit Profile"),
                  ProfileOption(icon: Icons.lock, title: "Change Password"),
                  ProfileOption(icon: Icons.settings, title: "Settings"),
                  ProfileOption(icon: Icons.logout, title: "Logout"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for profile options
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  ProfileOption({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          // Add functionality for each option
        },
      ),
    );
  }
}
