import 'package:flutter/material.dart';
import 'package:tamdansers/constants/app_colors.dart';
import 'package:tamdansers/constants/app_text_style.dart';
import 'package:tamdansers/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduPortal',
      theme: ThemeData(
        primaryColor: AppColors.primaryText,
        textTheme: TextTheme(
          displayLarge: AppTextStyle.title32,
          headlineMedium: AppTextStyle.screenTitle28,
          titleLarge: AppTextStyle.sectionTitle20,
          bodyLarge: AppTextStyle.fontsize18,
          bodyMedium: AppTextStyle.body,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
