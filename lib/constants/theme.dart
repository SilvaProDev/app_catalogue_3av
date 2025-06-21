import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';

class CustomTheme {
  static ThemeData get baseTheme {
    final bool isTablet = Device.screenType == ScreenType.tablet;
    
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: kPrimaryColor,
      primaryColor: kPrimaryColor,
      appBarTheme: AppBarTheme(
        toolbarHeight: isTablet ? 9.h : 7.h,
        backgroundColor: kPrimaryColor,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: isTablet ? 12.sp : 13.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
        ),
        iconTheme: IconThemeData(
          color: kOtherColor,
          size: isTablet ? 17.sp : 18.sp,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 11.sp,
          color: kTextLightColor,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontSize: 16.0,
          color: kTextBlackColor,
          height: 0.5,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextLightColor, width: 0.7),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextLightColor),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kTextLightColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kErrorBorderColor, width: 1.2),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kErrorBorderColor, width: 1.2),
        ),
      ),
      textTheme: _buildTextTheme(isTablet),
    );
  }

  static TextTheme _buildTextTheme(bool isTablet) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      headlineMedium : GoogleFonts.chewy(
        color: kTextWhiteColor,
        fontSize: isTablet ? 45.sp : 40.sp,
      ),
      bodyLarge: TextStyle(
        color: kTextWhiteColor,
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: kTextWhiteColor,
        fontSize: 28.0,
      ),
      titleMedium: TextStyle(
        color: kTextWhiteColor,
        fontSize: isTablet ? 14.sp : 17.sp,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: GoogleFonts.poppins(
        color: kTextWhiteColor,
        fontSize: isTablet ? 12.sp : 13.sp,
        fontWeight: FontWeight.w200,
      ),
      bodySmall: GoogleFonts.poppins(
        color: kTextLightColor,
        fontSize: isTablet ? 5.sp : 7.sp,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}