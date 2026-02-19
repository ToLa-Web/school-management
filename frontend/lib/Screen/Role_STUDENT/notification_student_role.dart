
// import 'package:flutter/material.dart';

// // --- 1. Notification Data Model ---
// class NotificationItem {
//   final IconData icon;
//   final Color iconColor;
//   final Color bgColor;
//   final String title;
//   final String subtitle;
//   final String fullDescription; // Added for detail view
//   final String time;
//   final String tag;
//   final Color tagColor;
//   bool isNew;

//   NotificationItem({
//     required this.icon,
//     required this.iconColor,
//     required this.bgColor,
//     required this.title,
//     required this.subtitle,
//     required this.fullDescription,
//     required this.time,
//     required this.tag,
//     required this.tagColor,
//     this.isNew = false,
//   });
// }

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   String activeFilter = "All";
//   final List<String> filters = [
//     "All",
//     "Attendance",
//     "Homework",
//     "Events",
//     "Seen",
//   ];

//   late List<NotificationItem> allNotifications;

//   @override
//   void initState() {
//     super.initState();
//     allNotifications = [
//       NotificationItem(
//         icon: Icons.help_outline_rounded,
//         iconColor: Colors.orange,
//         bgColor: const Color(0xFFFFF4E5),
//         title: "New Quiz Results",
//         subtitle: "You scored 95/100 on the Mathematics Chapter 3 quiz.",
//         fullDescription:
//             "Excellent work! Your performance in Mathematics Chapter 3: Algebra has been outstanding. You correctly answered 19 out of 20 questions. Keep up this momentum for the upcoming finals.",
//         time: "2h ago",
//         tag: "Homework",
//         tagColor: Colors.orange,
//         isNew: true,
//       ),
//       NotificationItem(
//         icon: Icons.edit_calendar_rounded,
//         iconColor: Colors.green,
//         bgColor: const Color(0xFFE8F5E9),
//         title: "New Homework Assigned",
//         subtitle: "Your Khmer teacher assigned a new essay: 'Environment'.",
//         fullDescription:
//             "A new essay topic 'Environmental Protection' has been assigned by Teacher Sokha. Due date: Friday, Oct 25th. Please ensure you follow the standard formatting guidelines.",
//         time: "5h ago",
//         tag: "Homework",
//         tagColor: Colors.green,
//         isNew: true,
//       ),
//       NotificationItem(
//         icon: Icons.calendar_month_rounded,
//         iconColor: Colors.blue,
//         bgColor: const Color(0xFFE3F2FD),
//         title: "Event Reminder",
//         subtitle: "Don't forget the 'Annual School Sports Day' tomorrow.",
//         fullDescription:
//             "Join us at the main stadium at 8:00 AM for the Annual Sports Day. Please bring your sports kit and water bottle. Lunch will be provided by the school.",
//         time: "Yesterday",
//         tag: "Events",
//         tagColor: Colors.blue,
//         isNew: false,
//       ),
//       NotificationItem(
//         icon: Icons.person_add_alt_1_rounded,
//         iconColor: Colors.purple,
//         bgColor: const Color(0xFFF3E5F5),
//         title: "Attendance Confirmed",
//         subtitle: "Your attendance record for September has been verified.",
//         fullDescription:
//             "Your attendance report for September 2024 shows 98% presence. This has been verified by the administration office and added to your permanent record.",
//         time: "2 days ago",
//         tag: "Attendance",
//         tagColor: Colors.purple,
//         isNew: false,
//       ),
//     ];
//   }

//   void _markAllAsRead() {
//     setState(() {
//       for (var item in allNotifications) {
//         item.isNew = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<NotificationItem> filteredList = allNotifications.where((item) {
//       if (activeFilter == "All") return true;
//       if (activeFilter == "Seen") return item.isNew == false;
//       return item.tag == activeFilter;
//     }).toList();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.arrow_back_ios_new,
//                 size: 18,
//                 color: Colors.black,
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//         title: const Text(
//           "Notifications",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _markAllAsRead,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD1E7E7),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 "Mark all as read",
//                 style: TextStyle(
//                   color: Color(0xFF007A7A),
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 45,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: filters.length,
//               itemBuilder: (context, index) {
//                 bool isSelected = activeFilter == filters[index];
//                 return GestureDetector(
//                   onTap: () => setState(() => activeFilter = filters[index]),
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 12),
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? const Color(0xFF007A7A)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(
//                         color: isSelected
//                             ? Colors.transparent
//                             : Colors.grey.shade200,
//                       ),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       filters[index],
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.grey.shade600,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: filteredList.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: filteredList.length,
//                     itemBuilder: (context, index) =>
//                         _buildNotificationCard(filteredList[index]),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationCard(NotificationItem item) {
//     return GestureDetector(
//       onTap: () {
//         // Mark as read when clicked
//         setState(() => item.isNew = false);
//         // Navigate to detail
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NotificationDetailScreen(item: item),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: const Color(0xFFEBF2F2)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.02),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: item.bgColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(item.icon, color: item.iconColor, size: 26),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         item.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             item.time,
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 11,
//                             ),
//                           ),
//                           if (item.isNew) ...[
//                             const SizedBox(width: 5),
//                             const CircleAvatar(
//                               radius: 4,
//                               backgroundColor: Color(0xFF007A7A),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     item.subtitle,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 13,
//                       height: 1.4,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: item.tagColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       item.tag,
//                       style: TextStyle(
//                         color: item.tagColor,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_off_outlined,
//             size: 60,
//             color: Colors.grey.shade300,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "No $activeFilter notifications",
//             style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- 2. Detail Screen ---
// class NotificationDetailScreen extends StatelessWidget {
//   final NotificationItem item;
//   const NotificationDetailScreen({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text("Details", style: TextStyle(color: Colors.black)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: item.bgColor,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Icon(item.icon, color: item.iconColor, size: 40),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               item.title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(item.time, style: TextStyle(color: Colors.grey.shade500)),
//             const SizedBox(height: 24),
//             const Divider(),
//             const SizedBox(height: 24),
//             Text(
//               item.fullDescription,
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.6,
//                 color: Colors.black87,
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF007A7A),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Got it",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

// --- 1. Notification Data Model ---
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String fullDescription;
  final String time;
  final String tag;
  final Color tagColor;
  bool isNew;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.fullDescription,
    required this.time,
    required this.tag,
    required this.tagColor,
    this.isNew = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // --- 2. State Variables ---
  String activeFilter = "All";
  final List<String> filters = [
    "All",
    "Attendance",
    "Homework",
    "Events",
    "Seen",
  ];

  late List<NotificationItem> allNotifications;

  @override
  void initState() {
    super.initState();
    allNotifications = [
      NotificationItem(
        icon: Icons.help_outline_rounded,
        iconColor: Colors.orange,
        bgColor: const Color(0xFFFFF4E5),
        title: "New Quiz Results",
        subtitle: "You scored 95/100 on the Mathematics Chapter 3 quiz.",
        fullDescription:
            "Excellent work! Your performance in Mathematics Chapter 3: Algebra has been outstanding. You correctly answered 19 out of 20 questions. Keep up this momentum for the upcoming finals.",
        time: "2h ago",
        tag: "Homework",
        tagColor: Colors.orange,
        isNew: true,
      ),
      NotificationItem(
        icon: Icons.edit_calendar_rounded,
        iconColor: Colors.green,
        bgColor: const Color(0xFFE8F5E9),
        title: "New Homework Assigned",
        subtitle: "Your Khmer teacher assigned a new essay: 'Environment'.",
        fullDescription:
            "A new essay topic 'Environmental Protection' has been assigned by Teacher Sokha. Due date: Friday, Oct 25th. Please ensure you follow the standard formatting guidelines for Khmer literature.",
        time: "5h ago",
        tag: "Homework",
        tagColor: Colors.green,
        isNew: true,
      ),
      NotificationItem(
        icon: Icons.calendar_month_rounded,
        iconColor: Colors.blue,
        bgColor: const Color(0xFFE3F2FD),
        title: "Event Reminder",
        subtitle: "Don't forget the 'Annual School Sports Day' tomorrow.",
        fullDescription:
            "Join us at the main stadium at 8:00 AM for the Annual Sports Day. Please bring your sports kit and water bottle. Lunch will be provided by the school cafeteria for all participants.",
        time: "Yesterday",
        tag: "Events",
        tagColor: Colors.blue,
        isNew: false,
      ),
      NotificationItem(
        icon: Icons.person_add_alt_1_rounded,
        iconColor: Colors.purple,
        bgColor: const Color(0xFFF3E5F5),
        title: "Attendance Confirmed",
        subtitle: "Your attendance record for September has been verified.",
        fullDescription:
            "Your attendance report for September 2024 shows 98% presence. This has been verified by the administration office and added to your permanent academic record.",
        time: "2 days ago",
        tag: "Attendance",
        tagColor: Colors.purple,
        isNew: false,
      ),
    ];
  }

  // --- 3. Logic: Mark All as Read ---
  void _markAllAsRead() {
    setState(() {
      for (var item in allNotifications) {
        item.isNew = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- 4. Advanced Filtering Logic ---
    List<NotificationItem> filteredList = allNotifications.where((item) {
      if (activeFilter == "All") return true;
      if (activeFilter == "Seen") return !item.isNew;
      return item.tag == activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD1E7E7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Mark all as read",
                style: TextStyle(
                  color: Color(0xFF007A7A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // --- 5. Filter Horizontal List ---
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                bool isSelected = activeFilter == filters[index];
                return GestureDetector(
                  onTap: () => setState(() => activeFilter = filters[index]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF007A7A)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade200,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // --- 6. Notification List ---
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildNotificationCard(filteredList[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // --- 7. UI Helper: Notification Card ---
  Widget _buildNotificationCard(NotificationItem item) {
    return GestureDetector(
      onTap: () {
        setState(() => item.isNew = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEBF2F2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            item.time,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                          if (item.isNew) ...[
                            const SizedBox(width: 5),
                            const CircleAvatar(
                              radius: 4,
                              backgroundColor: Color(0xFF007A7A),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.tag,
                      style: TextStyle(
                        color: item.tagColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "No $activeFilter notifications yet",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// --- 8. Modern Professional Detail Screen ---
class NotificationDetailScreen extends StatelessWidget {
  final NotificationItem item;
  const NotificationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: item.iconColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 40),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.tagColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.tag.toUpperCase(),
                        style: TextStyle(
                          color: item.tagColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "•  ${item.time}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "MESSAGE CONTENT",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.fullDescription,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.7,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
          // Floating Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF8FAFC).withOpacity(0),
                    const Color(0xFFF8FAFC).withOpacity(0.9),
                    const Color(0xFFF8FAFC),
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Dismiss Notification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
