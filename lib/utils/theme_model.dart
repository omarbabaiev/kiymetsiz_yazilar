
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ThemeModel{
  final photo;
  final TextStyle style;
  final Color appBarTextColor;
  final Color appBarIconColor;
  ThemeModel(this.photo, this.style, this.appBarTextColor, this.appBarIconColor,  );
}

List<ThemeModel> themes = [
  ThemeModel("w0", GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20), Colors.black, Colors.deepPurple ),
  ThemeModel("w1", GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w2", GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w3", GoogleFonts.kanit(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w4", GoogleFonts.josefinSans(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w5", GoogleFonts.libreBaskerville(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w6", GoogleFonts.noticiaText(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w7", GoogleFonts.spaceMono(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),
  ThemeModel("w9", GoogleFonts.arima(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20), Colors.white, Colors.white ),


];

