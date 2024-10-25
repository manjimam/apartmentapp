import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/Widgets/customtext.dart';
import 'package:flutter_application_3/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  var nameController = TextEditingController();
  var relationController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();
  var flatnoController = TextEditingController();
  late String memberIdForupdate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String?>> getSavedFlatNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? flatNo = prefs.getString('flatNo');
    String? role = prefs.getString('role');
    return {'flatNo': flatNo, 'role': role};
  }

  Future<void> addMembers() async {
    try {
      String defaultPassword =
          '123${nameController.text}'; // Use name in password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: defaultPassword);

      String useruid = userCredential.user!.uid;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedFlatNo = prefs.getString('flatNo');

      if (savedFlatNo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Flat number not found in shared preferences.')),
        );
        return;
      }

      // Save the family member's details to Firestore
      await FirebaseFirestore.instance
          .collection('residents')
          .doc(useruid)
          .set({
        'Name': nameController.text,
        'Email': emailController.text,
        'Relation': relationController.text,
        'Flatno': savedFlatNo,
        'Age': ageController.text,
        'role': 'Family Member',
        'useruid': useruid,
      });

      nameController.clear();
      relationController.clear();
      emailController.clear();
      ageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member Added Successfully')),
      );
    } catch (e) {
      print('Error adding member: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String?>>(
        future: getSavedFlatNo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          String? savedFlatNo = snapshot.data!['flatNo'];
          String? savedRole = snapshot.data!['role'];

          return StreamBuilder(
            stream: _firestore
                .collection('residents')
                .where('Flatno', isEqualTo: savedFlatNo)
                .where('role', isEqualTo: 'Family Member')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var member = streamSnapshot.data!.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Appcolor.primarycolor,
                          borderRadius: BorderRadius.circular(20)),
                      height: 130.h,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Custom_Text(
                                  'Name: ${member['Name']}',
                                  size: 12,
                                ),
                                Custom_Text(
                                  'Relation: ${(member.data() as Map<String, dynamic>).containsKey('Relation') ? member['Relation'] : ''}',
                                  size: 12,
                                ),
                                Custom_Text(
                                  'Age: ${member['Age']}',
                                  size: 12,
                                ),
                                Custom_Text(
                                  'Email: ${member['Email']}',
                                  size: 12,
                                ),
                                Custom_Text(
                                  'Flat no: ${member['Flatno'] ?? ''}',
                                  size: 12,
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('residents')
                                      .doc(member.id)
                                      .delete();
                                },
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Appcolor.maincolor,
                                ))
                          ],
                        ),
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
                title: Custom_Text('Add a member'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextField(
                      controller: relationController,
                      decoration: InputDecoration(hintText: 'Relation'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(hintText: 'Age'),
                    ),
                  ],
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
                      addMembers();
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
