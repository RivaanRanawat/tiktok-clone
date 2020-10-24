import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

latoStyle(double size, [Color color, FontWeight fw = FontWeight.w700]){
  return GoogleFonts.lato(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

ralewayStyle(double size, [Color color, FontWeight fw = FontWeight.w700]){
  return GoogleFonts.raleway(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

var userCollection = FirebaseFirestore.instance.collection("users");