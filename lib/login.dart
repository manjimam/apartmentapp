// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/BottomNavigation/bottomnav.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      String useruid = userCredential.user!.uid;
      QuerySnapshot userQuery = await _firestore
          .collection('residents')
          .where('Email', isEqualTo: emailcontroller.text.trim())
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userQuery.docs.first;
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('useruid', useruid);
        await prefs.setString('name', userDoc['Name']);
        await prefs.setString('email', userDoc['Email']);
        await prefs.setString('password', userDoc['Password']);
        await prefs.setString('address', userDoc['Adress']);
        await prefs.setString('dob', userDoc['DOB']);
        await prefs.setString('age', userDoc['Age']);
        await prefs.setString('phone', userDoc['Phone']);
        await prefs.setString('aadhar', userDoc['Aadhar']);
        await prefs.setString('flatNo', userDoc['Flatno']);
        await prefs.setString('imageUrl', userDoc['ImageURL'] ?? '');
        await prefs.setString('sex', userDoc['Sex']);
        await prefs.setString('status', userDoc['Status']);
        await prefs.setString('role', userDoc['role']);

        print("UserUID saved to SharedPreferences: $useruid");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loggined Successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavigation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 812.h,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/apartment.jpg'),
                fit: BoxFit.fitHeight)),
        child: Center(
          child: Container(
            height: 500.h,
            width: 250.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 91, 126, 180).withOpacity(.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50,
                    width: 250,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)))),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(200, 40)),
                        backgroundColor: WidgetStatePropertyAll(
                            const Color.fromARGB(255, 61, 102, 167))),
                    onPressed: registerUser,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
