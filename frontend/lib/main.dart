import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/constants/app_colors.dart';
import 'package:tamdansers/constants/app_text_style.dart';
import 'package:tamdansers/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable network font downloads — use only bundled/cached fonts.
  // This eliminates the jank on first render caused by async font loading.
  GoogleFonts.config.allowRuntimeFetching = false;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduPortal',
      // Apply BouncingScrollPhysics globally so all scrollables feel smooth.
      scrollBehavior: const _AppScrollBehavior(),
      builder: (context, child) {
        // Prevent system font scaling from breaking layouts
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(
              mediaQuery.textScaler.scale(1.0).clamp(0.85, 1.15),
            ),
          ),
          child: child!,
        );
      },
      theme: ThemeData(
        primaryColor: AppColors.primaryText,
        textTheme: TextTheme(
          displayLarge: AppTextStyle.title32,
          headlineMedium: AppTextStyle.screenTitle28,
          titleLarge: AppTextStyle.sectionTitle20,
          bodyLarge: AppTextStyle.fontsize18,
          bodyMedium: AppTextStyle.body,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}

/// Applies [BouncingScrollPhysics] to every scrollable in the app.
class _AppScrollBehavior extends ScrollBehavior {
  const _AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
