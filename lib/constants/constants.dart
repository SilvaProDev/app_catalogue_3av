import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

//colors
const Color kPrimaryColor = Color(0xFF345FB4);
const Color kSecondaryColor = Color(0xFF6789CA);
const Color kTextBlackColor = Color(0xFF313131);
const Color kTextWhiteColor = Color(0xFFFFFFFF);
const Color kContainerColor = Color(0xFF777777);
const Color kOtherColor = Color(0xFFF4F6F7);
const Color kTextLightColor = Color(0xFFA5A5A5);
const Color kErrorBorderColor = Color(0xFFE74C3C);

//default value
const kDefaultPadding = 20.0;

final sizedBox = SizedBox(height: kDefaultPadding.h);
final kWidthSizedBox = SizedBox(width: kDefaultPadding.w);
final kHalfSizedBox = SizedBox(height: (kDefaultPadding / 2).h);
final kHalfWidthSizedBox = SizedBox(width: (kDefaultPadding / 2).w);

final kTopBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(Device.screenType == ScreenType.tablet ? 40.w : 20.w),
  topRight: Radius.circular(Device.screenType == ScreenType.tablet ? 40.w : 20.w),
);

final kBottomBorderRadius = BorderRadius.only(
  bottomRight: Radius.circular(Device.screenType == ScreenType.tablet ? 40.w : 20.w),
  bottomLeft: Radius.circular(Device.screenType == ScreenType.tablet ? 40.w : 20.w),
);

final kInputTextStyle = GoogleFonts.poppins(
  color: kTextBlackColor,
  fontSize: 11.sp,
  fontWeight: FontWeight.w500,
);

//validation for mobile
const String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

//validation for email
const String emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';