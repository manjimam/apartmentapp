// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/BottomNavigation/Rented.dart';
import 'package:flutter_application_3/BottomNavigation/addmember.dart';
import 'package:flutter_application_3/BottomNavigation/myaccount.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';
import 'package:flutter_application_3/login.dart';
import 'package:flutter_application_3/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String Name = '';
  String Adress = '';
  String Phone = '';
  String Sex = '';
  String Age = '';
  String Aadhar = '';
  String DOB = '';
  String Flatno = '';
  String Status = '';
  String email = '';
  String? imageUrl;
  File? _image;

  XFile? pick;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('user_images').child('user images');
        await ref.putFile(_image!);

        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
        _updateUserImage(downloadUrl);
        print('Image uploaded: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateUserImage(String imageUrl) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString('useruid');

    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('residents')
          .doc(userId)
          .update({
        'imageURL': imageUrl,
      });
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? userId = pref.getString('useruid');
      print('SharedPreference UserID: $userId');

      if (userId != null && userId.isNotEmpty) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('residents')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            setState(() {
              Name = userData['Name'] ?? "";
              Adress = userData['Adress'] ?? "";
              Phone = userData['Phone'] ?? "";
              Sex = userData['Sex'] ?? '';
              Age = userData['Age'] ?? '';
              Aadhar = userData['Aadhar'] ?? "";
              DOB = userData['DOB'] ?? "";
              Flatno = userData['Flatno'] ?? "";
              Status = userData['Status'] ?? '';
              email = userData['Email'] ?? '';
              imageUrl = userData.containsKey('imageURL')
                  ? userData['imageURL']
                  : null;

              print("Document data: $userData");
            });
          } else {
            print("User data is null.");
          }
        } else {
          print("User not found in Firestore.");
        }
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Appcolor.maincolor,
        foregroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.08),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl!)
                        : AssetImage('assets/images/visitor.png')
                            as ImageProvider,
                    radius: 50,
                  ),
                  InkWell(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Appcolor.primarycolor,
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                    fixedSize: WidgetStatePropertyAll(Size(300.w, 45.h))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAccount(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Custom_Text('My Account'),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                    fixedSize: WidgetStatePropertyAll(Size(300.w, 45.h))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMember(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Custom_Text('Family Members'),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                )),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('residents')
                  .doc(userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  String? role = snapshot.data!['role'];
                  if (role != 'Rented') {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Rented()),
                        );
                      },
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              fixedSize:
                                  WidgetStatePropertyAll(Size(300.w, 45.h))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Rented(),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Custom_Text('Rented Owner'),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          )),
                    );
                  }
                  ;
                }
                return Container();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                    fixedSize: WidgetStatePropertyAll(Size(300.w, 45.h))),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Are You Sure?',
                          style: TextStyle(color: Appcolor.maincolor),
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Appcolor.maincolor)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ));
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Appcolor.maincolor)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Custom_Text('Logout'),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
