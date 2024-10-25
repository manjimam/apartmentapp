// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key});

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController flatNoController = TextEditingController();
  final TextEditingController aadharNoController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedSex;
  String? selectedStatus;
  XFile? aadharImage;

  final List<String> sexOptions = ['Male', 'Female', 'Other'];
  final List<String> statusOptions = ['Active', 'Inactive'];

  Future<void> _pickAadharImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      aadharImage = image;
    });
  }

  Future<String?> _uploadAadharImage() async {
    if (aadharImage != null) {
      // to Fire if () {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('aadhar_images/${aadharImage!.name}');

      // Upload the image
      await ref.putFile(File(aadharImage!.path));

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        String? imageUrl = await _uploadAadharImage();
        String useruid = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('residents')
            .doc(useruid)
            .set({
          'Name': nameController.text,
          'Email': emailController.text,
          'Password': passwordController.text,
          'Adress': addressController.text,
          'DOB': dobController.text,
          'Age': ageController.text,
          'Phone': phoneNoController.text,
          'Aadhar': aadharNoController.text,
          'Flatno': flatNoController.text,
          'ImageURL': imageUrl,
          'Sex': selectedSex,
          'Status': selectedStatus,
          'role': 'Owner',
          'useruid': useruid
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Added Successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Communication Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Sex'),
                    value: selectedSex,
                    items: sexOptions
                        .map((sex) => DropdownMenuItem<String>(
                              value: sex,
                              child: Text(sex),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSex = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your sex';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Date of Birth (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your DOB';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        dobController.text = pickedDate
                            .toIso8601String()
                            .split('T')[0]; // Format date
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: flatNoController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Flat No'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your flat number';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: aadharNoController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Aadhar No'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Aadhar number';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickAadharImage,
                        child: Text(aadharImage == null
                            ? 'Upload Aadhar Image'
                            : 'Change Aadhar Image'),
                      ),
                      SizedBox(width: 10),
                      if (aadharImage != null)
                        Text('Image Uploaded: ${aadharImage!.name}'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: TextFormField(
                    controller: phoneNoController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Phone No'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Status'),
                    value: selectedStatus,
                    items: statusOptions
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your status';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
