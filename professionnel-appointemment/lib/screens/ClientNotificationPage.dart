import 'package:flutter/material.dart';

class ClientNotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'Client Notification Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
