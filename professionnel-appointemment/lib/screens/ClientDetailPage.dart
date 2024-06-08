import 'package:flutter/material.dart';
import 'package:professionnel/screens/ClientCalendarPage.dart';
import 'package:professionnel/screens/map_screen.dart';

class ClientDetailsPage extends StatefulWidget {
  final Booking booking;

  const ClientDetailsPage({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  void addToCalendar(BuildContext context) {
    print('Request confirmed and added to the calendar: ${widget.booking.professional.FirstName}');
    Navigator.pop(context);
  }

  void rejectRequest(BuildContext context) {
    print('Request rejected: ${widget.booking.professional.FirstName}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.booking.photo);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.booking.professional.FirstName} Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional  Name: ${widget.booking.professional.FirstName} ${widget.booking.professional.LastName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${widget.booking.date}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${widget.booking.time}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${widget.booking.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            widget.booking.photo.isNotEmpty
                ? Image.network(
                    "http://192.168.1.12:4000/api/UploadImages/${widget.booking.photo}",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      mode: MapPageMode.view,
                      latitude: widget.booking.lat,
                      longitude: widget.booking.long,
                    ),
                  ),
                );
              },
              child: Text('View Location on Map'),
            ),
          ],
        ),
      ),
    );
  }
}
