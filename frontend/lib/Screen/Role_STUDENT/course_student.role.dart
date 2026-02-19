
// import 'package:flutter/material.dart';

// class ClassCourseStudentScreen extends StatefulWidget {
//   const ClassCourseStudentScreen({super.key});

//   @override
//   State<ClassCourseStudentScreen> createState() =>
//       _ClassCourseStudentScreenState();
// }

// class _ClassCourseStudentScreenState extends State<ClassCourseStudentScreen> {
//   final List<Map<String, dynamic>> _allCourses = [
//     {
//       'title': 'Mathematics',
//       'lessons': '10 Lessons',
//       'progress': 0.8,
//       'percent': '80%',
//       'color': Colors.blueAccent,
//       'icon': Icons.calculate_rounded,
//     },
//     {
//       'title': 'Physics',
//       'lessons': '14 Lessons',
//       'progress': 0.65,
//       'percent': '65%',
//       'color': Colors.orangeAccent,
//       'icon': Icons.bolt,
//     },
//     {
//       'title': 'Chemistry',
//       'lessons': '12 Lessons',
//       'progress': 0.75,
//       'percent': '75%',
//       'color': Colors.greenAccent,
//       'icon': Icons.science_rounded,
//     },
//     {
//       'title': 'Art History',
//       'lessons': '8 Lessons',
//       'progress': 0.3,
//       'percent': '30%',
//       'color': Colors.purpleAccent,
//       'icon': Icons.palette_rounded,
//     },
//   ];

//   List<Map<String, dynamic>> _foundCourses = [];

//   @override
//   void initState() {
//     _foundCourses = _allCourses;
//     super.initState();
//   }

//   void _runFilter(String enteredKeyword) {
//     List<Map<String, dynamic>> results = [];
//     if (enteredKeyword.isEmpty) {
//       results = _allCourses;
//     } else {
//       results = _allCourses
//           .where(
//             (course) => course["title"].toLowerCase().contains(
//               enteredKeyword.toLowerCase(),
//             ),
//           )
//           .toList();
//     }
//     setState(() => _foundCourses = results);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 120.0,
//             floating: true,
//             pinned: true,
//             elevation: 0,
//             backgroundColor: const Color(0xFFF8FAFC),
//             flexibleSpace: const FlexibleSpaceBar(
//               titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               title: Text(
//                 'My Courses',
//                 style: TextStyle(
//                   color: Color(0xFF1E293B),
//                   fontWeight: FontWeight.w900,
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: _buildSearchBar(),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(20),
//             sliver: _foundCourses.isNotEmpty
//                 ? SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) =>
//                           _buildModernCourseCard(_foundCourses[index]),
//                       childCount: _foundCourses.length,
//                     ),
//                   )
//                 : const SliverToBoxAdapter(
//                     child: Center(
//                       child: Text(
//                         "No courses found",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: TextField(
//         onChanged: (value) => _runFilter(value),
//         decoration: InputDecoration(
//           hintText: 'Search your subject...',
//           prefixIcon: const Icon(
//             Icons.search_rounded,
//             color: Color(0xFF007A7A),
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 15),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernCourseCard(Map<String, dynamic> course) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => LessonDetailScreen(course: course),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(24),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Hero(
//                 tag: course['title'],
//                 child: Container(
//                   height: 70,
//                   width: 70,
//                   decoration: BoxDecoration(
//                     color: course['color'].withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   child: Icon(course['icon'], color: course['color'], size: 30),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       course['title'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                       ),
//                     ),
//                     Text(
//                       course['lessons'],
//                       style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildProgressBar(course),
//                   ],
//                 ),
//               ),
//               const Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 14,
//                 color: Color(0xFFCBD5E1),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProgressBar(Map<String, dynamic> course) {
//     return Row(
//       children: [
//         Expanded(
//           child: LinearProgressIndicator(
//             value: course['progress'],
//             backgroundColor: Colors.grey[100],
//             color: course['color'],
//             borderRadius: BorderRadius.circular(10),
//             minHeight: 6,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           course['percent'],
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             fontSize: 12,
//             color: course['color'],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // --- NEW DETAIL SCREEN ---

// class LessonDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> course;
//   const LessonDetailScreen({super.key, required this.course});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 220,
//             pinned: true,
//             backgroundColor: course['color'],
//             leading: IconButton(
//               icon: const Icon(Icons.close, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Center(
//                 child: Hero(
//                   tag: course['title'],
//                   child: Icon(
//                     course['icon'],
//                     size: 80,
//                     color: Colors.white.withOpacity(0.8),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 course['title'],
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Course Content",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     "You have completed ${course['percent']} of this course.",
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//                   ...List.generate(5, (index) => _buildLessonItem(index + 1)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLessonItem(int index) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: CircleAvatar(
//         backgroundColor: course['color'].withOpacity(0.1),
//         child: Text("$index", style: TextStyle(color: course['color'])),
//       ),
//       title: Text("Lesson $index: Introduction to Topic"),
//       subtitle: const Text("Duration: 15:00 mins"),
//       trailing: const Icon(Icons.play_circle_fill_rounded, color: Colors.grey),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ClassCourseStudentScreen extends StatefulWidget {
  const ClassCourseStudentScreen({super.key});

  @override
  State<ClassCourseStudentScreen> createState() =>
      _ClassCourseStudentScreenState();
}

class _ClassCourseStudentScreenState extends State<ClassCourseStudentScreen> {
  final List<Map<String, dynamic>> _allCourses = [
    {
      'title': 'Mathematics',
      'lessons': '10 Lessons',
      'progress': 0.8,
      'percent': '80%',
      'color': Colors.blueAccent,
      'icon': Icons.calculate_rounded,
    },
    {
      'title': 'Physics',
      'lessons': '14 Lessons',
      'progress': 0.65,
      'percent': '65%',
      'color': Colors.orangeAccent,
      'icon': Icons.bolt,
    },
    {
      'title': 'Chemistry',
      'lessons': '12 Lessons',
      'progress': 0.75,
      'percent': '75%',
      'color': Colors.greenAccent,
      'icon': Icons.science_rounded,
    },
    {
      'title': 'Art History',
      'lessons': '8 Lessons',
      'progress': 0.3,
      'percent': '30%',
      'color': Colors.purpleAccent,
      'icon': Icons.palette_rounded,
    },
  ];

  List<Map<String, dynamic>> _foundCourses = [];

  @override
  void initState() {
    _foundCourses = _allCourses;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundCourses = _allCourses
          .where(
            (course) => course["title"].toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF8FAFC),
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                'My Learning',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSearchBar(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCourseCard(_foundCourses[index]),
                childCount: _foundCourses.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        onChanged: _runFilter,
        decoration: const InputDecoration(
          hintText: 'Search subjects...',
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF007A7A)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(course: course),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'icon_${course['title']}',
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: course['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(course['icon'], color: course['color'], size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildProgressBar(course),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> course) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              course['lessons'],
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            Text(
              course['percent'],
              style: TextStyle(
                color: course['color'],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: course['progress'],
          backgroundColor: Colors.grey[100],
          color: course['color'],
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

// --- MODERN DETAIL SCREEN ---

class LessonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;
  const LessonDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = course['color'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: themeColor,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [themeColor, themeColor.withOpacity(0.7)],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'icon_${course['title']}',
                    child: Icon(
                      course['icon'],
                      size: 100,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              title: Text(
                course['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Curriculum",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total duration: 4h 32m • ${course['lessons']}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _buildModernLessonItem(
                    1,
                    "Course Overview",
                    "12:00",
                    true,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    2,
                    "Fundamentals & Logic",
                    "45:30",
                    true,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    3,
                    "Deep Dive: Advanced Theory",
                    "22:15",
                    false,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    4,
                    "Interactive Workshop",
                    "15:00",
                    false,
                    themeColor,
                  ),
                  _buildLockedLesson(5, "Final Examination"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLessonItem(
    int index,
    String title,
    String time,
    bool isDone,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? color.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isDone ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      "$index",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_fill,
            color: isDone ? color : Colors.grey[300],
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildLockedLesson(int index, String title) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.lock, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.lock_outline, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
