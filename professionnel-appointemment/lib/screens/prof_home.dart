import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:professionnel/screens/Prof_profile.dart';
import 'package:professionnel/screens/work_requests.dart';
import 'package:professionnel/screens/map_screen.dart';
import 'package:http/http.dart' as http;

class ProfHome extends StatefulWidget {
  const ProfHome({Key? key}) : super(key: key);

  @override
  State<ProfHome> createState() => _ProfHomeState();
}

class _ProfHomeState extends State<ProfHome> {
  int _selectedIndex = 0;
  int requestsCount = 2; // Initialize requestsCount to 0


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return ProfHomeBox(requestsCount: requestsCount); // Show ProfHomeBox on the Home page
      case 1:
        return CalendarPage(acceptedRequests: []);
      case 2:
        return Center(child: Text('This is the Chat Page'));
      case 3:
        return ProfProfile();
      default:
        return Container();
    }
  }
}

class ProfHomeBox extends StatefulWidget {
  final int requestsCount;
  

  const ProfHomeBox({Key? key, required this.requestsCount}) : super(key: key);

  @override
  State<ProfHomeBox> createState() => _ProfHomeBoxState();
}

class _ProfHomeBoxState extends State<ProfHomeBox> {
  late List<WorkRequest> requests;
  List <WorkRequest> workrequests = [];

  Future<String> fetchUser(int id) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/users/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
      
          String userName =  responseData['firstName'] ?? 0;
      

        print("eeeeeeee"+userName);

        return userName;
      } else {
        print('No valid profession Id data found.');
        return ""; // Return null if the response data is null
      }
    } else {
      throw Exception('Failed to load profession Id: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profession Id: $e');
    return ""; // Return null in case of an error
  }
}



  Future<List<WorkRequest>> fetchWorkRequests() async {
  try {
    await initLocalStorage();
    String? profId = localStorage?.getItem('profId');
    final url = 'http://192.168.1.17:4000/api/workrequests/byProfId/$profId';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      List<WorkRequest> workrequests = await Future.wait(responseData.map((json) async {
        String firstName = await fetchUser(json['idclient']);
       

       

        return WorkRequest(
          id: json['id'],
          firstName: firstName,
          description: json['description'] ?? '',
          date: json ['date'] ??"",
          time: json['time'] ?? '',
          imageUrl: json['photo'] ,
          latuser: json['latitude'], // Initialize latitude
          longuser: json['longitude']
        );
      }).toList());
      setState(() {
        
      });

      return workrequests;
      
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching bookings: $e');
    return []; // Return an empty list
  }
}

  @override
  void initState() {
     fetchWorkRequests().then((value) {
      setState(() {
        workrequests = value;
      });
    });
    super.initState();
    // Initialize sample requests
    requests = [
      WorkRequest(
        id:1,
        firstName: 'John',
        description: 'Need assistance with plumbing',
        date: '',
        time: '', 
        imageUrl: 'image_url',
        latuser: 37.7749, // Sample latitude
        longuser: -122.4194, // Sample longitude
      ),
      WorkRequest(
        id:2,
        firstName: 'Alice',
        description: 'Looking for a carpenter',
        date: '',
        time: '', 
        imageUrl: 'image_url',
        latuser: 34.0522, // Sample latitude
        longuser: -118.2437, // Sample longitude
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return requests.isNotEmpty
        ? ListView.builder(
            itemCount: workrequests.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsPage(request: workrequests[index]),
                    ),
                  );
                },
                child: RequestTile(request: workrequests[index]),
              );
            },
          )
        : Center(
            child: Text('You have no requests'),
          );
  }
}

class RequestTile extends StatelessWidget {
  final WorkRequest request;


  const RequestTile({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
       
        title: Text('${request.firstName} needs your help'),
        subtitle: Text(""),
        trailing: Text(
          "",
          style: TextStyle(color: Colors.blue),
        ),
        
      ),
    );
  }
}

class RequestDetailsPage extends StatelessWidget {
  final WorkRequest request;

  const RequestDetailsPage({
    Key? key,
    required this.request,
  }) : super(key: key);

  // Method to show a pop-up message for confirming the request
  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('You accepted ${request.firstName}\'s request.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                // Add the request to the calendar (replace this with your implementation)
                addToCalendar(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to show a pop-up message for rejecting the request
  void showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('You rejected ${request.firstName}\'s request.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                // Remove the request permanently
                rejectRequest(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to add the confirmed request to the calendar
  void addToCalendar(BuildContext context) {
    // For demonstration, just print a message
    print('Request confirmed and added to the calendar: ${request.firstName}');
    // Close the details page after adding to the calendar
    Navigator.pop(context);
  }

  // Method to reject the request
  void rejectRequest(BuildContext context) {
    // For demonstration, just print a message
    print('Request rejected: ${request.firstName}');
    // Close the details page after rejecting the request
    Navigator.pop(context);
  }
  Future<void> HandleRequest(int requestid, int status, BuildContext context) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/api/workrequests/status/$requestid/$status';
    print(url);

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Create the PATCH request with the URL and headers
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;
       

   
      } else {
         String message = status == 1
          ? 'You Accepted the request.'
          : 'You Rejected the request.';
            showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Perform additional actions like removing the request permanently if needed
                    rejectRequest(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

      }
    } else {
      throw Exception('Failed to update work request status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error accepting or rejecting request: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    print("test"+request.imageUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('${request.firstName} Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Name: ${request.firstName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date : ${request.date}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Time : ${request.time}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
           
            Text(
              'Description: ${request.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
             
              request.imageUrl!=""?Image.network(
               "http://192.168.1.17:4000/api/UploadImages/"+request.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ):Container(),
              SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: () {
                print(request.latuser.toString());
                print (request.longuser.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      mode: MapPageMode.view,
                      latitude: request.latuser,
                      longitude: request.longuser,
                    ),
                  ),
                );
              },
              child: Text('View Location on Map'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    HandleRequest(request.id, 1,context);
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Confirm'),
                ),
                ElevatedButton(
                   onPressed: () {
                    HandleRequest(request.id, 2,context);
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Reject'),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
class CalendarPage extends StatefulWidget {
  final List<WorkRequest> acceptedRequests;

  const CalendarPage({Key? key, required this.acceptedRequests}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<WorkRequest>> futureAcceptedRequests;
    Future<String> fetchUser(int id) async {
  try {
    await initLocalStorage();
    String? userId = localStorage?.getItem('userId');
    final url = 'http://192.168.1.17:4000/users/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
      
          String userName =  responseData['firstName'] ?? 0;
      

        print("eeeeeeee"+userName);

        return userName;
      } else {
        print('No valid profession Id data found.');
        return ""; // Return null if the response data is null
      }
    } else {
      throw Exception('Failed to load profession Id: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching profession Id: $e');
    return ""; // Return null in case of an error
  }
}
Future<List<WorkRequest>> fetchAcceptedWorkRequests() async {
  try {
    await initLocalStorage();
    String? profId = localStorage?.getItem('profId');
    final url = 'http://192.168.1.17:4000/api/workrequests/byProfIdAcc/$profId'; // Update URL as necessary

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      List<WorkRequest> acceptedRequests = await Future.wait(responseData.map((json) async {
        String firstName = await fetchUser(json['idclient']);

        return WorkRequest(
          id: json['id'],
          firstName:firstName,
          description: json['description'] ?? '',
          date: json['date'] ?? '',
          time: json['time'] ?? '',
          imageUrl: json['photo'],
          latuser: json['latitude'],
          longuser: json['longitude']
        );
      }).toList());

      return acceptedRequests;
    } else {
      throw Exception('Failed to load accepted requests: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching accepted requests: $e');
    return [];
  }
}

  @override
  void initState() {
    super.initState();
    futureAcceptedRequests = fetchAcceptedWorkRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Requests'),
      ),
      body: FutureBuilder<List<WorkRequest>>(
        future: futureAcceptedRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accepted requests found.'));
          }

          final acceptedRequests = snapshot.data!;

          return ListView.builder(
            itemCount: acceptedRequests.length,
            itemBuilder: (context, index) {
              final request = acceptedRequests[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailsPage(request: request),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(request.firstName),
                    subtitle: Text(request.description),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
