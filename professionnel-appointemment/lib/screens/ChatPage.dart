import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:professionnel/screens/ClientCalendarPage.dart';
import 'package:professionnel/screens/ClientNotificationPage.dart';
import 'package:professionnel/screens/ClientProfilePage.dart';
import 'package:professionnel/screens/HomeProf.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
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
        title: Text('Chat'),
      ),
      body: Center(
        child: Text(
          'Chat Page',
          style: TextStyle(fontSize: 20),
        ),
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
