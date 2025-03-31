import 'package:flutter/material.dart';
import 'package:vakku_mini_project/choosing_page.dart';
import 'package:vakku_mini_project/main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAge;

  void _navigateToNextPage() {
    if (_nameController.text.isEmpty || _selectedAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your details.')),
      );
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 171, 211, 52),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card Container
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff5ACD05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ENTER YOUR DETAILS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontFamily: 'ADLaMDisplay',
                      ),
                    ),
                    SizedBox(height: 20),

                    // Name Input
                    CustomInputField(
                      label: 'Name',
                      controller: _nameController,
                      hintText: 'Enter your name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 15),

                    // Age Dropdown
                    CustomDropdown(
                      label: 'Age',
                      selectedValue: _selectedAge,
                      onChanged: (value) {
                        setState(() {
                          _selectedAge = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Continue Button
              ElevatedButton(
                onPressed: _navigateToNextPage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  backgroundColor: Color(0xff5ACD05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ADLaMDisplay',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Input Field
class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const CustomInputField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'ADLaMDisplay',
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (value) {
            name = value;
          },
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Color(0xff5ACD05)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// Custom Dropdown Field
class CustomDropdown extends StatelessWidget {
  final String label;
  final int? selectedValue;
  final Function(int?) onChanged;

  const CustomDropdown({
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'ADLaMDisplay',
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedValue,
              hint: Text('Select Age'),
              icon: Icon(Icons.arrow_drop_down, color: Color(0xff5ACD05)),
              isExpanded: true,
              items: List.generate(
                100,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
