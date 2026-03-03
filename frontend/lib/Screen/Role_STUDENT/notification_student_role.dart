import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<NotificationItem> _filteredList = [];

  List<NotificationItem> _applyFilter() {
    return allNotifications.where((item) {
      if (activeFilter == "All") return true;
      if (activeFilter == "Seen") return !item.isNew;
      return item.tag == activeFilter;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    allNotifications = [
      NotificationItem(
        icon: Icons.emoji_events_rounded,
        iconColor: const Color(0xFFFFB75E),
        bgColor: const Color(0xFFFFB75E).withValues(alpha: 0.15),
        title: "New Quiz Results",
        subtitle: "You scored 95/100 on the Mathematics Chapter 3 quiz.",
        fullDescription:
            "Excellent work! Your performance in Mathematics Chapter 3: Algebra has been outstanding. You correctly answered 19 out of 20 questions. Keep up this momentum for the upcoming finals.",
        time: "2h ago",
        tag: "Homework",
        tagColor: const Color(0xFFFFB75E),
        isNew: true,
      ),
      NotificationItem(
        icon: Icons.menu_book_rounded,
        iconColor: const Color(0xFF50E3C2),
        bgColor: const Color(0xFF50E3C2).withValues(alpha: 0.15),
        title: "New Homework Assigned",
        subtitle: "Your Khmer teacher assigned a new essay: 'Environment'.",
        fullDescription:
            "A new essay topic 'Environmental Protection' has been assigned by Teacher Sokha. Due date: Friday, Oct 25th. Please ensure you follow the standard formatting guidelines for Khmer literature.",
        time: "5h ago",
        tag: "Homework",
        tagColor: const Color(0xFF50E3C2),
        isNew: true,
      ),
      NotificationItem(
        icon: Icons.event_available_rounded,
        iconColor: const Color(0xFF4A90E2),
        bgColor: const Color(0xFF4A90E2).withValues(alpha: 0.15),
        title: "Event Reminder",
        subtitle: "Don't forget the 'Annual School Sports Day' tomorrow.",
        fullDescription:
            "Join us at the main stadium at 8:00 AM for the Annual Sports Day. Please bring your sports kit and water bottle. Lunch will be provided by the school cafeteria for all participants.",
        time: "Yesterday",
        tag: "Events",
        tagColor: const Color(0xFF4A90E2),
        isNew: false,
      ),
      NotificationItem(
        icon: Icons.fact_check_rounded,
        iconColor: const Color(0xFFB86DFF),
        bgColor: const Color(0xFFB86DFF).withValues(alpha: 0.15),
        title: "Attendance Confirmed",
        subtitle: "Your attendance record for September has been verified.",
        fullDescription:
            "Your attendance report for September 2024 shows 98% presence. This has been verified by the administration office and added to your permanent academic record.",
        time: "2 days ago",
        tag: "Attendance",
        tagColor: const Color(0xFFB86DFF),
        isNew: false,
      ),
    ];
    _filteredList = _applyFilter();
  }

  // --- 3. Logic: Mark All as Read ---
  void _markAllAsRead() {
    setState(() {
      for (var item in allNotifications) {
        item.isNew = false;
      }
      _filteredList = _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Bounceable(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF0D3B66),
            ),
          ),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Bounceable(
            onTap: _markAllAsRead,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D3B66).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Mark all read",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0D3B66),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // --- 5. Filter Horizontal List ---
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                bool isSelected = activeFilter == filters[index];
                return Bounceable(
                  onTap: () => setState(() {
                    activeFilter = filters[index];
                    _filteredList = _applyFilter();
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0D3B66)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
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
          ),
          const SizedBox(height: 24),
          // --- 6. Notification List ---
          Expanded(
            child: _filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildNotificationCard(_filteredList[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // --- 7. UI Helper: Notification Card ---
  Widget _buildNotificationCard(NotificationItem item) {
    return Bounceable(
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
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            item.time,
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (item.isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: item.tagColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.tag.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: item.tagColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 60,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No $activeFilter notifications yet",
            style: GoogleFonts.outfit(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You're all caught up!",
            style: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
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
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Bounceable(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0D3B66),
              size: 18,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: item.iconColor.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 50),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: item.tagColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.tag.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: item.tagColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "•  ${item.time}",
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "MESSAGE CONTENT",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.fullDescription,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey.shade700,
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
                    const Color(0xFFF3F6F8).withValues(alpha: 0),
                    const Color(0xFFF3F6F8).withValues(alpha: 0.9),
                    const Color(0xFFF3F6F8),
                  ],
                ),
              ),
              child: Bounceable(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D3B66),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Dismiss Notification",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
