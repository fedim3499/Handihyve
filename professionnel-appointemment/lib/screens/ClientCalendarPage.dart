import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:professionnel/screens/ChatPage.dart';
import 'package:professionnel/screens/ClientDetailPage.dart';
import 'package:professionnel/screens/ClientProfilePage.dart';
import 'package:professionnel/screens/HomeProf.dart';
import 'package:professionnel/screens/work_requests.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class ClientCalendarPage extends StatefulWidget {
  const ClientCalendarPage({Key? key}) : super(key: key);

  @override
  _ClientCalendarPageState createState() => _ClientCalendarPageState();
}

class _ClientCalendarPageState extends State<ClientCalendarPage> {
  List<Booking> bookings = [];
   List<Professional> professionals = [];
   Professional? professional;
   int? professionId; // List of bookings
   String? professionName;

  @override
  void initState() {
    super.initState();
    // Fetch bookings from backend and update the 'bookings' list
    // Example:
    fetchBookings().then((value) {
      setState(() {
        bookings = value;
      });
    });
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
        title: Text('Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {

                return BookingCard(booking: bookings[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fetch bookings from backend
Future<Professional?> fetchProfessional(int id) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/users/prof/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
        Professional professional = Professional(
          FirstName: responseData['firstName'] ?? '',
          LastName: responseData['lastName'] ?? '',
          professionId: responseData['professionId'] ?? 0, // Provide a default value
        );

        print(professional);

        return professional;
      } else {
        print('No valid professional data found.');
        return null; // Return null if the response data is null
      }
    } else {
      throw Exception('Failed to load professional: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching professional: $e');
    return null; // Return null in case of an error
  }
}

Future<int?> fetchProfessionType(int id) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/profession/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
      
          professionId =  responseData['professionTypeId'] ?? 0;
      

        print(professionId);

        return professionId;
      } else {
        print('No valid profession Id data found.');
        return null; // Return null if the response data is null
      }
    } else {
      throw Exception('Failed to load profession Id: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profession Id: $e');
    return null; // Return null in case of an error
  }
}
Future<String?> fetchProfessionName(int? id) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/profession/GetProfessionByTypeId/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic>) {
        // Handle response as a map
        final String? professionName = responseData['professionName'];
        print(professionName);
        return professionName;
      } else if (responseData is List) {
        // Handle response as a list
        if (responseData.isNotEmpty && responseData[0] is Map<String, dynamic>) {
          final String? professionName = responseData[0]['professionName'];
          print(professionName);
          return professionName;
        } else {
          print('No valid profession name data found in list.');
          return null;
        }
      } else {
        print('Invalid response data type.');
        return null;
      }
    } else {
      throw Exception('Failed to load profession name: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profession name: $e');
    return null;
  }
}
Future<List<Booking>> fetchBookings() async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/api/workrequests/byClientId/$userId';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      List<Booking> bookings = await Future.wait(responseData.map((json) async {
        Professional? professional = await fetchProfessional(json['idProf']);
        int? professionId = await fetchProfessionType((json['idProf']));
        String? professionName = await fetchProfessionName(professionId);
        BookingStatus status = getStatusFromString(json['status']);
        return Booking(
          profilePicture: json['profilePicture'] ?? '',
          name: json['description'] ?? '',
          specialty: professionName ?? '',
          status: status,
          professional: professional ?? Professional(FirstName: '', LastName: '', professionId: 0),
          description: json['description'] ?? '',
          date: json['date'] ?? '',
          time: json['time'] ?? '',
          photo: json['photo'] ?? '',
          long: (json['longitude']) ,
          lat: (json['latitude']),
          
        );
      }).toList());

      return bookings;
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching bookings: $e');
    return []; // Return an empty list
  }
}
BookingStatus getStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return BookingStatus.pending;
    case 'accepted':
      return BookingStatus.confirmed;
    case 'rejected':
      return BookingStatus.rejected;
    default:
      return BookingStatus.pending; // Default case if status is unexpected
  }
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

class Booking {
  final String profilePicture;
  final String name;
  final String specialty;
  final Professional professional;
  final String description;
  final String date;
  final String time;
  final String photo;
  final double long;
  final double lat;

  final BookingStatus status;
  

  Booking({
    required this.profilePicture,
    required this.name,
    required this.specialty,
    required this.professional,

    required this.status,
    required this.description,
    required this.date,
    required this.time,
    required this.photo,
    required this.long,
    required this.lat
  });
}
class Professional {
  final String FirstName;
  final String LastName;
  final int professionId;


 

  Professional({
    required this.FirstName,
    required this.LastName,
    required this.professionId
  
  });
}

enum BookingStatus {
  pending,
  confirmed,
  rejected,
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.orange; 
    String statusText = 'Pending'; 

    if (booking.status == BookingStatus.confirmed) {
      statusColor = Colors.green; 
      statusText = 'Confirmed'; 
    } else if (booking.status == BookingStatus.rejected) {
      // Hide the booking card if it's rejected
      statusColor = Colors.red; 
      statusText = 'Rejected';
    }

    return InkWell(
      onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClientDetailsPage(booking: booking))),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(booking.profilePicture),
          ),
          title: Text(booking.professional.FirstName + " " + booking.professional.LastName),
          subtitle: Text(booking.specialty),
          trailing: Text(
            statusText,
            style: TextStyle(color: statusColor),
          ),
          
        ),
      ),
    );
  }
    
}
