import 'dart:io'; // Import dart:io for File class
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:professionnel/screens/signin_screen.dart'; // Import image_picker package


File? _imageFile; // Declare a File variable to hold the selected image file

class ProfProfile extends StatefulWidget {
  @override
  _ProfProfileState createState() => _ProfProfileState();
}

class _ProfProfileState extends State<ProfProfile> {
  late ImagePicker _imagePicker;
  late String _profileImagePath = ''; // Initialize profile image path as empty string

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

/* Future<void> _selectAndSetProfilePicture() async {
  final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

 if (pickedFile != null) {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
     uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
     ]
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = File(croppedFile.path); // Update _imageFile with cropped image
      });
    }
  }
  
}*/

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
  return Scaffold(
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

}