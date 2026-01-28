class AppRoutes {
  //Auth
  static const String splashScreen = "/splash_screen";
  static const String roleSelectionScreen = "/role_selection_screen";
  //teacher
  static const String authOptionTeacherScreen = "/auth_option_teacher_screen";
  static const String teacherLoginScreen = "/teacher_login_screen";
}




// class _StudentDashboardState extends State<StudentDashboard> {
//   int _pageIndex = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   final List<Widget> _screens = [
//     const StudentHomeContent(),
//     Center(
//       child: Text("បណ្ណាល័យ (Library)", style: AppTextStyle.sectionTitle20),
//     ),
//     Center(child: Text("សារ (Messages)", style: AppTextStyle.sectionTitle20)),
//     const StudentEditProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F9),
//       body: IndexedStack(index: _pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: _pageIndex,
//         height: 60.0,
//         items: const <Widget>[
//           Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
//           Icon(Icons.menu_book, size: 30, color: Colors.white),
//           Icon(Icons.chat_bubble, size: 30, color: Colors.white),
//           Icon(Icons.settings, size: 30, color: Colors.white),
//         ],
//         color: const Color(0xFF007A7A),
//         buttonBackgroundColor: const Color(0xFF007A7A),
//         backgroundColor: const Color(0xFFF5F7F9),
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 300),
//         onTap: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
