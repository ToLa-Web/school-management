import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/contants/app_colors.dart';
// ignore: depend_on_referenced_packages
// import 'package:tamdansers_app/constants/app_colors.dart';

class AppTextStyle {
  static final title32 = GoogleFonts.kantumruyPro(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  static final screenTitle28 = GoogleFonts.kantumruyPro(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  static final sectionTitle20 = GoogleFonts.kantumruyPro(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static final fontsize18 = GoogleFonts.kantumruyPro(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final body = GoogleFonts.kantumruyPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
