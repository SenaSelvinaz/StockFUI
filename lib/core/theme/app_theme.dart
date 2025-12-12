// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Temel renk paletini tanımlayabiliriz
  static const Color primaryColor = Color.fromARGB(255, 11, 26, 94);
  static const Color backgroundColor = Colors.white;
  static const Color appBarColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color secondaryTextColor = Color.fromARGB(255, 100, 100, 100);

  static final ThemeData lightTheme = ThemeData(
    // Genel Arka Plan Rengi
    scaffoldBackgroundColor: backgroundColor,
    
    // AppBar Teması
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: appBarColor,
      iconTheme: IconThemeData(color: textColor, size: 24),
      titleTextStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),

    // ElevatedButton Teması (Sizin "Kaydet" Butonunuz)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          //color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor,width: 2.0),
      ),
    ),
  );
    
    
 
}