import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:professionnel/screens/HomeProf.dart';
import 'package:professionnel/screens/prof_home.dart';
import 'package:professionnel/themes/theme.dart';
import 'package:professionnel/screens/signup_screen.dart';
import 'package:professionnel/widgets/custom_scaffold.dart';
import 'package:localstorage/localstorage.dart';
import 'urladress.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formSignInKey = GlobalKey<FormState>();
  String _emailError = '';
  String _passwordError = '';
  int? professionId;

  Future<void> _login() async {
    setState(() {
      _emailError = '';
      _passwordError = '';
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
    }
    if (_emailError.isNotEmpty || _passwordError.isNotEmpty) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    var url = Uri.parse('http://192.168.1.17:4000/users/authenticate');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': email, 'password': password}),
    );

    await initLocalStorage();

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool isProfession = responseData['isProfession'];
      int userId = responseData['id'];
      localStorage?.setItem('userId', userId.toString());

      if (!isProfession) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeProf()),
        );
      } else {
        fetchProfessionalId(userId);
          
          print("professionId $professionId");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfHome()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please verify your login credentials'),
      ));
    }
  }
  Future<int?> fetchProfessionalId(int id) async {
  try {
    await initLocalStorage();
    final url = 'http://192.168.1.17:4000/users/$id';

    final response = await http.get(Uri.parse(url));

    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic>? responseData = json.decode(response.body) as Map<String, dynamic>?;

      if (responseData != null) {
      
          professionId =  responseData['professionId'] ?? 0;
          localStorage?.setItem('profId', professionId.toString());
      

        print("test $professionId");

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

  @override
  Widget build(BuildContext context) {
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
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome to Handy Hive ',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
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
                          errorText: _emailError.isNotEmpty ? _emailError : null,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
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
                          errorText: _passwordError.isNotEmpty ? _passwordError : null,
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
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
}
