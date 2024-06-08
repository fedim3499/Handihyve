// ignore: depend_on_referenced_packages
// ignore_for_file: non_constant_identifier_na, use_build_context_synchronously, unused_local_variable
//es, unused_import, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';

// ignore: duplicate_ignore
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:professionnel/screens/signin_screen.dart';
import 'package:professionnel/widgets/custom_scaffold.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// ignore: unused_import
import 'package:professionnel/models/professiontype.dart';
// ignore: depend_on_referenced_packages
import 'package:professionnel/themes/theme.dart';

//import 'package:flutter_front/screens/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum UserType { professional, client }

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int?>> professionTypes = [];
  bool agreePersonalData = true;
  String _password = ''; // Variable to store the password
  // ignore: unused_field
  String _confirmPassword = ''; // Variable to store the confirmed password
  bool _obscureText = true; // Variable to toggle password visibility
  int? role;
  String country = "";
  String state = "";
  String city = "";
  String FirstName = "";
  String lastname = "";
  String email = "";
  String PhoneNumber = "";
  String? professionType;
  int? professionTypeId;
  String address = "";
  String taxRegistrationNumber = "";

  get Http => null;

  Map<String, dynamic> constructFormData() {
    return {
      'email': email,
      'password': _password,
      'role': role,
      'FirstName': FirstName,
      'lastname': lastname,
      'PhoneNumber': PhoneNumber,
      'professionType': professionType,
      'professionTypeId': professionTypeId,
      'address': address,
      'city': city,
      'country': country,
      'state': state,
      'taxRegistrationNumber': taxRegistrationNumber,
    };
  }
  

  Future<List<DropdownMenuItem<int?>>> _getProfessionTypesDropDown() async {
    List<DropdownMenuItem<int?>> dropDownList = [];

    await getData()
        .then((value) => {
              for (Map i in value)
                {
                  dropDownList.add(DropdownMenuItem<int?>(
                    value: i['id'],
                    child: Text(i['professionName']),
                  ))
                }
            })
        .timeout(const Duration(seconds: 1));

    return dropDownList;
  }

  Future<dynamic> getData() async {
    final url = Uri.parse('http://192.168.1.17:4000/ProfessionType');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(url, headers: headers);
    var data = jsonDecode(response.body);
    return data;
  }

  Future<void> signUp() async {
    final url = Uri.parse('http://192.168.1.17:4000/Users/createUser');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(constructFormData());
    final response = await http.post(url, headers: headers, body: body);
   print(body+"hhhhhhh");
    if (response.statusCode == 200) {
      _formSignupKey.currentState!.reset();
      email = '';
      _password = '';
      _confirmPassword = '';
      role = null;
      FirstName = '';
      lastname = '';
      PhoneNumber = '';
      professionType = '';
      professionTypeId = null;
      address = '';
      city = '';
      country = '';
      state = '';
      taxRegistrationNumber = '';

      Navigator.pushReplacement(
        context,
        // ignore: prefer_const_constructors
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } else {
      throw Exception('Failed to register');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    _getProfessionTypesDropDown().then((value) => professionTypes = value);
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            FirstName = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          } else if (!_isValidName(value)) {
                            return 'First name can only contain letters and spaces';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('First Name'),
                          hintText: 'Enter First Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            lastname = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          } else if (!_isValidName(value)) {
                            return 'Last name can only contain letters and spaces';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Last Name'),
                          hintText: 'Enter Last Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          } else if (!_isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CSCPicker(
                                    showStates: true,
                                    showCities: true,
                                    flagState: CountryFlag.ENABLE,
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                    ),
                                    disabledDropdownDecoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                    ),
                                    countrySearchPlaceholder: "Country",
                                    stateSearchPlaceholder: "State",
                                    citySearchPlaceholder: "City",
                                    countryDropdownLabel: "*Country",
                                    stateDropdownLabel: "*State",
                                    cityDropdownLabel: "*City",
                                    selectedItemStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    dropdownHeadingStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    dropdownItemStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    dropdownDialogRadius: 10.0,
                                    searchBarRadius: 10.0,
                                    onCountryChanged: (value) {
                                      setState(() {
                                        country = value;
                                      });
                                    },
                                    onStateChanged: (String? value) {
                                      setState(() {
                                        state = value ?? '';
                                      });
                                    },
                                    onCityChanged: (String? value) {
                                      setState(() {
                                        city = value ?? '';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'Enter Phone Number',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialCountryCode: 'TN',
                              onChanged: (value) {
                                PhoneNumber = value.completeNumber;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        obscureText: _obscureText,
                        onChanged: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          } else if (!_isValidPassword(value)) {
                            _showToast(
                                'Password must contain at least one uppercase, one lowercase, one symbol, and one digit');
                            return 'Invalid password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // confirmation password
                      TextFormField(
                        obscureText: _obscureText,
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Confirm Password';
                          } else if (value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Confirm Password'),
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // i am a
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'I am a:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              // Professional radio button
                              Radio(
                                value: 0,
                                groupValue: role,
                                onChanged: (int? value) {
                                  setState(() {
                                    role = value;
                                  });
                                },
                              ),
                              Text('Professional'),

                              // Client radio button
                              Radio(
                                value: 1,
                                groupValue: role,
                                onChanged: (int? value) {
                                  setState(() {
                                    role = value;
                                  });
                                },
                              ),
                              Text('Client'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // Choose a profession
                      if (role == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose a profession:',
                              style: TextStyle(fontSize: 16),
                            ),
                            DropdownButtonFormField<int?>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: professionTypes,
                              onChanged: (int? value) {
                                professionTypeId = value;
                              },
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  taxRegistrationNumber = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter taxRegistrationNumber ';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('taxRegistrationNumber'),
                                hintText: 'Enter taxRegistrationNumber ',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // Address
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  address = value;
                                });
                                const SizedBox(
                                  height: 25.0,
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Address'),
                                hintText: 'Enter Address',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),

                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: signUp,
                          child: const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidName(String value) {
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegExp.hasMatch(value);
  }

  bool _isValidPassword(String value) {
    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegExp.hasMatch(value);
  }

  void _showToast(String s) {}
}

bool _isValidEmail(String value) {
  final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
  return nameRegExp.hasMatch(value);
}
