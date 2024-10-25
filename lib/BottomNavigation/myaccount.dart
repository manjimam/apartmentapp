import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';
import 'package:flutter_application_3/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
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

  @override
  void initState() {
    super.initState();
    fetchuserDetails();
  }

  Future<void> fetchuserDetails() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Custom_Text("My Account"),
      ),
      body: Center(
        child: Container(
          height: 500.h,
          width: 400.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 222, 233, 250),
          ),
          child: Column(
            children: [
              Details(infoKey: 'Name :', info: Name),
              Details(infoKey: 'Adress :', info: Adress),
              Details(infoKey: 'Contact No :', info: Phone),
              Details(infoKey: 'Birth Date :', info: DOB),
              Details(infoKey: 'Gender :', info: Sex),
              Details(infoKey: 'Age :', info: Age),
              Details(infoKey: 'Aadhar No :', info: Aadhar),
              Details(infoKey: 'Status :', info: Status)
            ],
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Custom_Text(
            infoKey,
          ),
          Custom_Text(info),
        ],
      ),
    );
  }
}
