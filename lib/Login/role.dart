// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:tamdansers/contants/app_image.dart';

// // 1. If you have an AppImages class, import it here.
// // If not, I have replaced it with a string placeholder below.

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // FIX: Define 'size' using MediaQuery to get screen dimensions
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F7),
//       appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: Row()),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             SizedBox(
//               height: size.height * 0.35,
//               child: SvgPicture.asset(
//                 AppImages.imageSelectRole,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const SizedBox(height: 30),
//             _buildRoleCard(
//               context,
//               icon: Icons.menu_book,
//               title: "គ្រូបង្រៀន",
//               subtitle:
//                   "គ្រប់គ្រងថ្នាក់រៀន កត់ត្រាវត្តមាន និងដាក់ពិន្ទុលើកិច្ចការសិស្ស។",
//               buttonText: "បន្តក្នុងនាមជា គ្រូបង្រៀន",
//               route: '/login-teacher',
//             ),
//             _buildRoleCard(
//               context,
//               icon: Icons.school,
//               title: "សិស្ស",
//               subtitle:
//                   "មើលកាលវិភាគរបស់អ្នក ពិនិត្យលទ្ធផល និងដាក់កិច្ចការផ្ទះ។",
//               buttonText: "បន្តក្នុងនាមជា សិស្ស",
//               route: '/login-student',
//             ),
//             _buildRoleCard(
//               context,
//               icon: Icons.people,
//               title: "មាតាបិតា",
//               subtitle: "តាមដានវឌ្ឍនភាព មើលការជូនដំណឹង និងទំនាក់ទំនងជាមួយគ្រូ។",
//               buttonText: "បន្តក្នុងនាមជា មាតាបិតា",
//               route: '/ParentLoginScreen',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required String buttonText,
//     required String route,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: const Color(0xFF007A8C), size: 30),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             subtitle,
//             style: const TextStyle(color: Colors.black54, fontSize: 14),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, route),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFE0F2F1),
//                 foregroundColor: const Color(0xFF007A8C),
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(buttonText),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:tamdansers/contants/app_image.dart';

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Defines 'size' to calculate responsive heights
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F4F7),
//       appBar: AppBar(elevation: 0),
//       // Use Padding instead of SingleChildScrollView to disable scrolling
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Column(
//           children: [
//             // Reduced image height to ensure everything fits on one screen
//             SizedBox(
//               height: size.height * 0.45,
//               child: SvgPicture.asset(
//                 AppImages.imageSelectRole,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "ជ្រើសរើសតួនាទីរបស់អ្នក",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const Spacer(), // Pushes the cards towards the bottom

//             _buildRoleCard(
//               context,
//               icon: Icons.menu_book,
//               title: "គ្រូបង្រៀន",
//               subtitle: "គ្រប់គ្រងថ្នាក់រៀន កត់ត្រាវត្តមាន។",
//               buttonText: "បន្តក្នុងនាមជា គ្រូបង្រៀន",
//               route: '/login-teacher',
//             ),
//             _buildRoleCard(
//               context,
//               icon: Icons.school,
//               title: "សិស្ស",
//               subtitle: "មើលកាលវិភាគ និងពិនិត្យលទ្ធផល។",
//               buttonText: "បន្តក្នុងនាមជា សិស្ស",
//               route: '/login-student',
//             ),
//             _buildRoleCard(
//               context,
//               icon: Icons.people,
//               title: "មាតាបិតា",
//               subtitle: "តាមដានវឌ្ឍនភាពរបស់សិស្ស។",
//               buttonText: "បន្តក្នុងនាមជា មាតាបិតា",
//               route: '/ParentLoginScreen',
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required String buttonText,
//     required String route,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: const Color(0xFF007A8C), size: 24),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             height: 40,
//             child: ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, route),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFE0F2F1),
//                 foregroundColor: const Color(0xFF007A8C),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(buttonText),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers/contants/app_image.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light greyish background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Title at the top
              const Text(
                "ជ្រើសរើសមុខងារ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Illustration Image
              SvgPicture.asset(
                AppImages.imageSelectRole,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),

              // 3. Teacher Button
              _buildLargeButton(
                text: "គ្រូបង្រៀន",
                onPressed: () => Navigator.pushNamed(context, '/login-teacher'),
              ),
              const SizedBox(height: 15),

              // 4. Student Button
              _buildLargeButton(
                text: "សិស្ស",
                onPressed: () => Navigator.pushNamed(context, '/login-student'),
              ),
              const SizedBox(height: 15),

              // 5. Parent Button
              _buildLargeButton(
                text: "អាណាព្យាបាលសិស្ស",
                onPressed: () =>
                    Navigator.pushNamed(context, '/ParentLoginScreen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom helper to create the blue rounded buttons
  Widget _buildLargeButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF4A89F3,
          ), // Bright blue color from image
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Fully rounded corners
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
