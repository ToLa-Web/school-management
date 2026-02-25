import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Notification Model ---
class TeacherNotification {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String description;
  final String time;
  final String category;
  final Color categoryColor;
  bool isRead;

  TeacherNotification({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.time,
    required this.category,
    required this.categoryColor,
    this.isRead = false,
  });
}

class TeacherNotificationScreen extends StatefulWidget {
  const TeacherNotificationScreen({super.key});

  @override
  State<TeacherNotificationScreen> createState() =>
      _TeacherNotificationScreenState();
}

class _TeacherNotificationScreenState extends State<TeacherNotificationScreen> {
  String activeFilter = "All";
  final List<String> filters = ["All", "Requests", "System", "Urgent"];

  late List<TeacherNotification> notifications;

  @override
  void initState() {
    super.initState();
    notifications = [
      TeacherNotification(
        icon: Icons.person_add_rounded,
        iconColor: const Color(0xFF4A90E2),
        bgColor: const Color(0xFF4A90E2).withValues(alpha: 0.1),
        title: "Leave Request",
        subtitle: "Sok Pong has requested a 2-day leave.",
        description:
            "Student Sok Pong (Grade 10B) has submitted a leave request for Feb 24-25 due to family personal matters. Please review and approve or decline this request in the management portal.",
        time: "10m ago",
        category: "Requests",
        categoryColor: const Color(0xFF4A90E2),
      ),
      TeacherNotification(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFFF6B6B),
        bgColor: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
        title: "Urgent Meeting",
        subtitle: "Staff meeting in the conference room at 2 PM.",
        description:
            "There is an emergency administrative meeting today at 2:00 PM to discuss the upcoming semester planning and curriculum updates. Attendance is mandatory for all senior teachers.",
        time: "1h ago",
        category: "Urgent",
        categoryColor: const Color(0xFFFF6B6B),
      ),
      TeacherNotification(
        icon: Icons.update_rounded,
        iconColor: const Color(0xFF50E3C2),
        bgColor: const Color(0xFF50E3C2).withValues(alpha: 0.1),
        title: "System Update",
        subtitle: "Grade submission deadline extended.",
        description:
            "The deadline for final grade submission for Semester 1 has been extended to Friday, March 1st. Please ensure all student records are updated before the new deadline.",
        time: "5h ago",
        category: "System",
        categoryColor: const Color(0xFF0D3B66),
      ),
      TeacherNotification(
        icon: Icons.assignment_ind_rounded,
        iconColor: const Color(0xFFFFB75E),
        bgColor: const Color(0xFFFFB75E).withValues(alpha: 0.1),
        title: "New Parent Link",
        subtitle: "Parent 'Mao Sophal' linked to student 'Pong'.",
        description:
            "A new parent account for Mao Sophal has been successfully linked to student Sok Pong. You can now communicate with them directly through the portal.",
        time: "Yesterday",
        category: "Requests",
        categoryColor: const Color(0xFFFFB75E),
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      for (var n in notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TeacherNotification> filteredList = notifications.where((n) {
      if (activeFilter == "All") return true;
      return n.category == activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Bounceable(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0D3B66),
              size: 18,
            ),
          ),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: const Color(0xFF0D3B66),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              "Read All",
              style: GoogleFonts.inter(
                color: const Color(0xFF4A90E2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildNotificationCard(filteredList[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isSelected = activeFilter == filters[index];
          return Bounceable(
            onTap: () => setState(() => activeFilter = filters[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D3B66) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index],
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(TeacherNotification item) {
    return Bounceable(
      onTap: () {
        setState(() => item.isRead = true);
        _showNotificationDetail(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: item.isRead
              ? null
              : Border.all(
                  color: const Color(0xFF0D3B66).withValues(alpha: 0.1),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 24),
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
                        item.category.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.categoryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        item.time,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 20),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF95738),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetail(TeacherNotification item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D3B66),
                        ),
                      ),
                      Text(
                        item.time,
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Text(
              "Full Description",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  item.description,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D3B66),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Close Window",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
            Icons.notifications_none_rounded,
            size: 80,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 20),
          Text(
            "All caught up!",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          Text(
            "No $activeFilter notifications found.",
            style: GoogleFonts.inter(color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }
}
