import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter/foundation.dart';

import 'dart:typed_data';

import 'package:professionnel/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';

class ClientWorkRequestPage extends StatefulWidget {
  final int? id;
  ClientWorkRequestPage(this.id);

  @override
  _ClientWorkRequestPageState createState() => _ClientWorkRequestPageState();
}

class _ClientWorkRequestPageState extends State<ClientWorkRequestPage> {
  String? imageData; // Variable to store base64-encoded image data
  String? fileName; // Variable to store base64-encoded image data
  String? UrlApi = "http://192.168.1.12:4000/api/workrequests";
  String? date; // Variable to store base64-encoded image data
  XFile? aa; // Variable to store base64-encoded image data

  final picker = ImagePicker();
  late String _description;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _selectedImage;
  String? selectedLocationText;
  String? selected;
  double? latuser; // Store latitude
  double? longuser; // Store longitude

  @override
  void initState() {
    super.initState();
    _description = '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        date = DateFormat('yyyy-MM-dd').format(pickedDate);
        print(date);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _submitWorkRequest() async {
    // Ensure all required fields are filled
    if (date == null || _selectedTime == null || _description.isEmpty || latuser == null || longuser == null) {
      print('Please fill all required fields.');
      return;
    }

    // Create JSON object
    await initLocalStorage();
    String? userId =  localStorage?.getItem('userId');
    print(userId);
    print(widget.id);
    Map<String, dynamic> jsonObject = {
      'date': date,
      'time': _selectedTime!.format(context),
      'photo': fileName,
      'description': _description,
      'latitude': latuser,
      'longitude': longuser,
      'idclient': int.tryParse(userId!) ?? 0,
       'idProf': widget.id,

    };
    
 


    // Convert the map to a JSON string
    String jsonString = json.encode(jsonObject);

    // Print the JSON string to the console
    print('JSON Data: $jsonString');

    try {
      // Make POST request
      http.Response response = await http.post(
        Uri.parse(UrlApi!),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonString,
      );

      // Check the response status
      if (response.statusCode == 200) {
        uploadImage();
        print('Request successful: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadImage() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.12:4000/api/UploadImages/upload'),
      );

      // Check if the platform is web or mobile
      if (kIsWeb) {
        // If it's web, encode the image as base64 and add it to the request body
        var bytes = await _selectedImage!.readAsBytes();
        var imageData = base64Encode(bytes);
        request.fields['ImageFile'] = imageData;
      } else {
        // If it's mobile, attach the image file to the request
        request.files.add(
          await http.MultipartFile.fromPath(
            'ImageFile',
            selected!, // !!!!!!!!!!!!!!!!!
          ),
        );
      }

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await streamedResponse.stream.bytesToString();
        var parsedResponse = json.decode(response);
        print(parsedResponse);
      } else {
        print(
            'Failed to upload image. Error: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Work Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate != null
                    ? _selectedDate!.toString().split(' ')[0]
                    : 'Select Date'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Select Time'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                      imageData =
                          path.basenameWithoutExtension(_selectedImage!.path);
                      fileName =
                          pickedFile.name; // Get the file name from pickedFile
                      selected = pickedFile.path;
                      print('Selected file name: $fileName');
                    });
                  }
                },
                child: Text(_selectedImage != null
                    ? 'Image Selected'
                    : 'Select Image (Optional)'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Navigate to map page to select location
                  LatLng? selectedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage(mode: MapPageMode.select)),
                  );
                  if (selectedLocation != null) {
                    setState(() {
                      // Update the button text to indicate location selected
                      selectedLocationText = 'Location Selected';
                      latuser = selectedLocation.latitude;
                      longuser = selectedLocation.longitude;
                    });
                  }
                },
                child: Text(selectedLocationText ?? 'Select Location *'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _submitWorkRequest(),
                child: Text('Submit Work Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
