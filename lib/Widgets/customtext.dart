import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Custom_Text extends StatelessWidget {
  final Color? color;
  final String text;
  final double? size;

  const Custom_Text(
    this.text, {
    this.color,
     this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:GoogleFonts.poppins(textStyle: TextStyle(fontSize: size,color: color))
    );
  }
}
