import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'package:professionnel/screens/ChatPage.dart';
import 'package:professionnel/screens/ClientCalendarPage.dart';
import 'package:professionnel/screens/ClientNotificationPage.dart';
import 'package:professionnel/screens/ClientProfilePage.dart';
import 'package:professionnel/screens/SeeAll.dart';
import 'package:professionnel/widgets/text_widget.dart';

void main() {
  runApp(MaterialApp(
    home: HomeProf(),
  ));
}

class HomeProf extends StatefulWidget {
  const HomeProf({Key? key}) : super(key: key);

  @override
  State<HomeProf> createState() => _HomeProfState();
}

class _HomeProfState extends State<HomeProf> {
  var opacity = 0.0;

  bool position = true;
  List<Widget> professionTypeWidgetList = [];
  Set<int> addedProfessionIds =
      {}; // Utilisez un Set pour stocker les IDs des professions ajoutées

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
      setState(() {});
    });
  }

  animator() {
    if (opacity == 1) {
      opacity = 0;
      position = false;
    } else {
      opacity = 1;
      position = true;
    }
    setState(() {});
  }

  Future<dynamic> _professionTypeList() async {
    final url = Uri.parse('http://192.168.1.17:4000/ProfessionType');
    final headers = {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);
    var data = jsonDecode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 0;
    if (professionTypeWidgetList.isEmpty) {
      _professionTypeList().then((value) {
        for (Map i in value) {
          int id = i['id'];
          // Vérifiez si l'ID de la profession n'a pas déjà été ajouté
          if (!addedProfessionIds.contains(id)) {
            professionTypeWidgetList.add(
              professionCard(id, i['professionName'], "", i['path'], () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeeAll(professionTypeId: id),
                  ),
                );
              }),
            );
            addedProfessionIds.add(
                id); // Ajoutez l'ID de la profession à la liste des IDs ajoutés
          }
        }
        setState(() {});
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              ListView(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    top: position ? 1 : 100,
                    right: 20,
                    left: 20,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: opacity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                  "Welcome",
                                  17,
                                  Colors.black.withOpacity(.7),
                                  FontWeight.bold),
                            ],
                          ),
                    
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    top: position ? 50 : 500,
                    left: 20,
                    right: 20,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: opacity,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              "Our Professions ",
                              25,
                              Colors.black.withOpacity(0.7),
                              FontWeight.bold,
                              letterSpace: 0,
                            ),
                     
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: professionTypeWidgetList,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: _selectedIndex,
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
    );
  }

  Widget professionCard(int professionTypeId, String name, String specialist,
      String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: double.maxFinite,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(asset),
            fit: BoxFit.cover,
          ),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: TextWidget(
              name,
              24,
              Colors.white,
              FontWeight.bold,
              letterSpace: 0,
            ),
          ),
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
