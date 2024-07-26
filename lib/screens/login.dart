import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medmart/screens/register.dart';
import 'package:http/http.dart' as http;
import 'package:medmart/services/user.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  login(User user) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/login'),
      headers: <String, String>{
        'Content-type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,  dynamic>{
        'usernameOrEmail' : user.email,
        'password' : user.password
      }),
    );
    if (response.statusCode == 200) {
      return 'Login successful';
    } else {
      return 'Login failed: ${response.body}';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/hh.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          // add the picture here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/removebg.png',
                  width: 360,
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                height: 400.0,
                child: Card(
                  color: Colors.white60,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password should be 8 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          const SizedBox(height: 30.0),
                          Column(
                            children: [
                              SizedBox(
                                width: 200.0,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 73, 105, 76),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      User user = User(id: '' , username: '', email: _email, password: _password);
                                      login(user);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Logging in")),
                                      );
                                      Navigator.pushNamed(context, '/');
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("not accepted")),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'or',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 201.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Register(),
                                      ),
                                    );
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 77, 77, 153)),
                                  ),
                                  child: const Text(
                                    'Create an Account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
