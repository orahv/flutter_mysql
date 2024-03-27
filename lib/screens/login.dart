// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/dump_page/mini_menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/components/consts.dart';
import 'package:flutter_project/dump_page/pageOne.dart';

import 'package:flutter_project/dump_page/pagerTwo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  bool isLoading = false;
  bool error = false;
  bool sucess = false;
  String errormsg = '';

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Future login() async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/login.php');
    try {
      response = await http.post(uri, body: {
        "username": ctrlUsername.text,
        "password": ctrlPassword.text,
      });
    } catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Error!! Check your connection',
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["error"]) {
        setState(() {
          isLoading = false;
          error = true;
          errormsg = data['message'];
          Fluttertoast.showToast(
            msg: errormsg!,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
        });
      } else {
        if (data["success"]) {
          setState(() {
            error = false;
            isLoading = false;
          });

          Fluttertoast.showToast(
            msg: 'Login Successful',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tes(),
            ),
          );
        } else {
          isLoading = false;
          error = true;
          errormsg = data['message'];
          Fluttertoast.showToast(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            msg: errormsg!,
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      }
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Error code :  ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', ctrlUsername.text);
    prefs.setString('password', ctrlPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset("assets/images/logo.png"),
                ),

                SizedBox(
                  height: 10,
                ),
                //TextFormField untuk Username
                TextFormField(
                  controller: ctrlUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                //TextFormField untuk Password
                TextFormField(
                  controller: ctrlPassword,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        !_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                // Button Login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Kode ketika form sudah terisi
                        /*
                        if (ctrlUsername.text == username &&
                            ctrlPassword.text == password) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => PageOne()));
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('Password Salah'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }*/
                        login();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.indigo),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
