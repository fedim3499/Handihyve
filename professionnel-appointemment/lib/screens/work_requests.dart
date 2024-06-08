import 'package:flutter/material.dart';
import 'package:professionnel/screens/ClientCalendarPage.dart';

class WorkRequest {
  final int id;
  final String firstName;
  final String description;
  final String date;
  final String time;
  final String imageUrl;
  final double latuser; // Add latitude
  final double longuser; // Add longitude

  WorkRequest({
    required this.id,
    required this.firstName,
    required this.description,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.latuser, // Initialize latitude
    required this.longuser, // Initialize longitude
  });
}



class WorkRequestsScreen extends StatelessWidget {
  WorkRequestsScreen(this.booking);
  Booking booking ;

  @override
  Widget build(BuildContext context) {
    print(booking.name);
    var workRequests;
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Requests'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final request = workRequests[index];
          return ExpansionTile(
            title: Text('Request ${request.id}'),
            children: [
              ListTile(
                title: Text('Date: ${request.date}'),
              ),
              ListTile(
                title: Text('Time: ${request.time}'),
              ),
              ListTile(
                title: Text(booking.name),
              ),
              ListTile(
                title: Text('Image URL: ${request.imageUrl}'), // Display image URL
              ),
              // You can load the image here using NetworkImage(request.imageUrl)
            ],
          );
        },
      ),
    );
  }
}
