import 'dart:io';
import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:professionnel/screens/ChatPage.dart';
import 'package:professionnel/screens/ClientCalendarPage.dart';
import 'package:professionnel/screens/HomeProf.dart';
import 'package:professionnel/screens/signin_screen.dart';

class ClientProfilePage extends StatefulWidget {
  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  late ImagePicker _imagePicker;
  late String _profileImagePath = ''; // Initialize profile image path as empty string

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _selectAndSetProfilePicture() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path; // Update profile image path
        print('Selected profile image path: $_profileImagePath');
      });
    }
  }

Future<void> logout(BuildContext context) async {
  // Create an instance of LocalStorage
   await initLocalStorage();
   localStorage.clear();

  // Navigate to SignInScreen
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInScreen()));
}



  @override
  Widget build(BuildContext context) {
    int _selectedIndex;
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blue, // Change color as needed
        buttonBackgroundColor: Colors.blue, // Change color as needed
        height: 50,
        items: [
          Icon(Icons.home_filled, size: 30, color: Colors.white),
          Icon(Icons.calendar_today, size: 30, color: Colors.white),
          Icon(Icons.message, size: 30, color: Colors.white),
          Icon(Icons.account_circle_outlined,
              size: 30, color: Colors.white), // Added profile icon
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          handleNavigation(index);
        },
      ),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          // Profile Picture Section
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: _selectAndSetProfilePicture,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundColor: Colors.blue, // Set background color to blue
                child: _profileImagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.2),
                        child: Image.file(
                          File(_profileImagePath),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.person, size: MediaQuery.of(context).size.width * 0.2, color: Colors.white), // Use person icon as a placeholder
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // Edit Profile Button Section
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                // Implement edit profile functionality
              },
              child: Text('Edit Profile'),
            ),
          ),
          // Spacer
          Expanded(
            child: SizedBox(),
          ),
          // Logout Button Section
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: (){
                  logout(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Logout'),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
   void handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeProf()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClientCalendarPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClientProfilePage()));
        break;
    }
  }
}
