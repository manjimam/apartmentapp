// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_3/BottomNavigation/Account.dart';
import 'package:flutter_application_3/BottomNavigation/explore.dart';
import 'package:flutter_application_3/BottomNavigation/home.dart';
import 'package:flutter_application_3/BottomNavigation/sos.dart';
import 'package:flutter_application_3/styles/colors.dart';
class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _pageindex=0;
  final PageController _pageController=PageController();

  List<Widget> pages=[
    Home(),
    Explore(),
    Sos(),
    Account(),
  ];
   List<Widget> items = [
    Icon(
      Icons.home,
      size: 30,
      color:Appcolor.maincolor,
    ),
     Icon(
      Icons.explore,
      size: 30,
      color:Appcolor.maincolor,
    ),
    Icon(
      Icons.sos_sharp,
      size: 30,
      color:Appcolor.maincolor,
    ),
    Icon(
      Icons.person,
      size: 30,
      color:Appcolor.maincolor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        backgroundColor: Appcolor.maincolor,
        index: _pageindex,
        onTap: (index) {
          setState(() {
            _pageindex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageindex = index;
          });
        },
        children: pages,
      ),
    );
  }
}