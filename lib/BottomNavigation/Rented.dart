import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';
import 'package:flutter_application_3/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rented extends StatefulWidget {
  const Rented({super.key});

  @override
  State<Rented> createState() => _RentedState();
}

class _RentedState extends State<Rented> {
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
  final List<String> sexOptions = ['Male', 'Female', 'Other'];
  final List<String> statusOptions = ['Active', 'Inactive'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String?>> getSavedUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? flatNo = prefs.getString('flatNo');
    String? role = prefs.getString('role');
    return {'flatNo': flatNo, 'role': role};
  }

  Future<void> renteduser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        String useruid = userCredential.user!.uid;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedFlatNo =
            prefs.getString('flatNo') ?? flatNoController.text;

        Map<String, dynamic> userData = {
          'Name': nameController.text,
          'Email': emailController.text,
          'Address': addressController.text,
          'DOB': dobController.text,
          'Age': ageController.text,
          'Phone': phoneNoController.text,
          'Aadhar': aadharNoController.text,
          'Flatno': savedFlatNo,
          'Sex': selectedSex,
          'Status': selectedStatus,
          'role': 'Rented',
          'useruid': useruid,
        };

        print("Saving user data: $userData");

        await _firestore.collection('residents').doc(useruid).set(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Added Successfully')),
        );

        clearFormFields();
      } catch (e) {
        print('Error adding user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding user: ${e.toString()}')),
        );
      }
    }
  }

  void clearFormFields() {
    nameController.clear();
    addressController.clear();
    dobController.clear();
    ageController.clear();
    flatNoController.clear();
    aadharNoController.clear();
    phoneNoController.clear();
    emailController.clear();
    passwordController.clear();
    selectedSex = null;
    selectedStatus = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String?>>(
        future: getSavedUserDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          String? savedFlatNo = snapshot.data!['flatNo'];
          String? savedRole = snapshot.data!['role'];

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('residents')
                .where('Flatno', isEqualTo: savedFlatNo)
                .where('role', isEqualTo: 'Rented')
                .snapshots(),
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (streamSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No rented users found.'));
              }
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var rented = streamSnapshot.data!.docs[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Appcolor.primarycolor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 130.h,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Custom_Text('Name: ${rented['Name']}', size: 12),
                          Custom_Text('Email: ${rented['Email']}', size: 12),
                          Custom_Text('Address: ${rented['Address'] ?? 'N/A'}',
                              size: 12),
                          Custom_Text('Phone no: ${rented['Phone'] ?? 'N/A'}',
                              size: 12),
                          Custom_Text('Gender: ${rented['Sex'] ?? 'N/A'}',
                              size: 12),
                          Custom_Text('Age: ${rented['Age']}', size: 12),
                          Custom_Text('Aadhar No: ${rented['Aadhar'] ?? 'N/A'}',
                              size: 12),
                          Custom_Text('Status: ${rented['Status'] ?? 'N/A'}',
                              size: 12),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolor.primarycolor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Custom_Text('Add a Rented user'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(hintText: 'Adress'),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(hintText: 'Age'),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(hintText: 'Sex'),
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
                      TextFormField(
                        controller: dobController,
                        decoration: InputDecoration(
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
                      TextFormField(
                        controller: aadharNoController,
                        decoration: InputDecoration(hintText: 'Aadhar No'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Aadhar number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phoneNoController,
                        decoration: InputDecoration(hintText: 'Phone No'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: flatNoController,
                        decoration: InputDecoration(hintText: 'Flat No'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter flat no';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(hintText: 'Status'),
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
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      renteduser();
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.person_add_alt_1,
          color: Appcolor.maincolor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
