import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:professionnel/models/profession.dart';
import 'package:professionnel/models/professiontype.dart';
import 'package:professionnel/screens/homeProf.dart';
import 'package:professionnel/widgets/text_widget.dart';
import 'package:professionnel/res/lists.dart';
import 'Profilemec.dart';
import 'package:http/http.dart' as http;

class SeeAll extends StatefulWidget {
  final int? professionTypeId;
  final String professionName = "";
  const SeeAll({Key? key, this.professionTypeId,professionName}) : super(key: key);

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  double opacity = 0.0;
  bool position = false;
  List<Profession> professionList = [];
  List<int> professionIdsList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
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

  Future<dynamic> _professionList(int? professionTypeId,professionName) async {
    final url = Uri.parse(
        'http://192.168.1.12:4000/Profession/GetProfessionByTypeId/' +
            professionTypeId.toString());
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'professionTypeId': professionTypeId},);

    final response = await http.get(url, headers: headers);
    var data = jsonDecode(response.body);
    setState(() {
      
    });

    return data;
  }

  Widget build(BuildContext context) {
    int? professionTypeId = widget.professionTypeId;
    String professionName = widget.professionName;
    _professionList(professionTypeId,professionName).then((value) => {
          for (Map i in value)
            {
              // Check if the profession ID already exists in the list
              if (!professionIdsList.contains(i['id']))
                {
                  professionIdsList.add(i['id']),
                  professionList.add(Profession(
                      id: i['id'],
                      image: 'assets/images/vector.png',
                      userName: i['userName'],
                      specialist: i['professionName'])),

                }
            }
        });
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 10,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            AnimatedPositioned(
              top: position ? size.height * 0.1 : size.height * 0.15,
              left: size.width * 0.05,
              right: size.width * 0.05,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: SizedBox(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      professionList.length==0? TextWidget(
                      " No professionals Near you",
                        22,
                        Colors.black,
                        FontWeight.bold,
                        letterSpace: 0,
                      ):
                      
                      
                       TextWidget(
                        professionList[0].specialist.toString() + " Near you",
                        22,
                        Colors.black,
                        FontWeight.bold,
                        letterSpace: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              top: position ? size.height * 0.18 : size.height * 0.22,
              left: size.width * 0.05,
              right: size.width * 0.05,
              bottom: 0, // Adjusted to align with the bottom
              duration: const Duration(milliseconds: 500),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: opacity,
                child: SizedBox(
                  height: size.height * 0.7,
                  child: ListView.builder(
                    itemCount: professionList.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        animator();
                        await Future.delayed(const Duration(milliseconds: 500));
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profilemec(
                              id: professionList[index].id,
                              image: AssetImage(professionList[index].image),
                              name: professionList[index].userName,
                              specialist: professionList[index].specialist,
                              specialties: '',
                              phoneNumber: '',
                              email: '',
                            ),
                          ),
                        );
                        animator();
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: double.infinity,
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage(professionList[index].image),
                                backgroundColor: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    professionList[index].userName,
                                    20,
                                    Colors.black,
                                    FontWeight.bold,
                                    letterSpace: 0,
                                  ),
                                  const SizedBox(height: 5),
                                  TextWidget(
                                    professionList[index].specialist,
                                    17,
                                    Colors.black,
                                    FontWeight.bold,
                                    letterSpace: 0,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.navigation_sharp,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
