// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';
import 'package:flutter_application_3/adduser.dart';

import 'package:flutter_application_3/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Appcolor.maincolor,
        leading: CircleAvatar(),
        title: Custom_Text(
          "Name \n Flat no",
          color: Colors.white,
          size: 18.spMin,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.chat_bubble, color: Colors.white, size: 40.r)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_active,
                  color: Colors.white, size: 40.r)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 200.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 227, 227, 188),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Custom_Text('20/10/2024'),
                            Custom_Text(
                              'Navarathri Decoration  ',
                              size: 16.sp,
                              color: const Color.fromARGB(255, 232, 33, 33),
                            ),
                            Center(
                                child: Custom_Text(
                              '₹300',
                              size: 24.spMin,
                            )),
                            Custom_Text(
                                'Pay before 13/10/24. Ignore if already  paid')
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 200.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 195, 240, 196),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(23),
              child: Custom_Text(
                'Explore',
                size: 24.spMin,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/visitor.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Visitors',
                        size: 18,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/payment.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Payments',
                        size: 18,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/pool.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Amenities',
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/helpdesk.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Helpdesk',
                        size: 18,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/parking.png',
                        fit: BoxFit.cover,
                        height: 80,
                      ),
                      Custom_Text(
                        '      Vehicle \nManagement',
                        size: 16,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/services.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Services',
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolor.primarycolor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/document.png',
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      Custom_Text(
                        'Documents',
                        size: 18,
                      )
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    height: 150.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Appcolor.primarycolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/apartment.png',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                        Custom_Text(
                          'My apartment',
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
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
                      if (role == 'admin') {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Adduser()),
                            );
                          },
                          child: Container(
                            height: 150.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Appcolor.primarycolor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/apartment.jpg',
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                                Custom_Text(
                                  'Add user',
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }

                    return Container();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
