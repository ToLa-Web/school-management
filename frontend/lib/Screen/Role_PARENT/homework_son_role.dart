
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart'; // Adjust path

class ParentHomeworkScreen extends StatefulWidget {
  const ParentHomeworkScreen({super.key});

  @override
  State<ParentHomeworkScreen> createState() => _ParentHomeworkScreenState();
}

class _ParentHomeworkScreenState extends State<ParentHomeworkScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Colors
  final Color primary = const Color(0xFF0D3B66);
  final Color bg = const Color(0xFFF3F6F8);
  final Color accent = const Color(0xFF4A90E2);
  final Color warning = const Color(0xFFFF6B6B);
  final Color pending = const Color(0xFFFFB75E);
  final Color success = const Color(0xFF50E3C2);

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeworkHome(),
      const Center(
        child: Text(
          "Library",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text(
          "Messages",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      const StudentEditProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      extendBody: true, // important for curved nav transparency
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Bounceable(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF0D3B66),
                    size: 20,
                  ),
                ),
              ),
              title: Text(
                'Homework Center',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
              centerTitle: true,
              actions: [
                Bounceable(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: primary,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65,
        items: const <Widget>[
          Icon(Icons.assignment_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book_rounded, size: 30, color: Colors.white),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.person_outline_rounded, size: 30, color: Colors.white),
        ],
        color: primary,
        buttonBackgroundColor: accent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }

  Widget _buildHomeworkHome() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStudentHeader(),
                const SizedBox(height: 24),
                _buildProgressCard(),
                const SizedBox(height: 28),
                _buildSearchBar(),
                const SizedBox(height: 28),
                _buildStatusFilters(),
                const SizedBox(height: 32),
                Text(
                  'Upcoming Assignments',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildHomeworkCard(
              subject: 'Mathematics',
              title: 'Quadratic Equations',
              desc:
                  'Complete the worksheet on page 42. Show all solution steps clearly.',
              teacher: 'Ms. Sarah Jenkins',
              due: 'Overdue by 2 days',
              status: 'Overdue',
              statusColor: warning,
              icon: Icons.calculate_rounded,
            ),
            _buildHomeworkCard(
              subject: 'English Literature',
              title: 'Book Report: The Hobbit',
              desc:
                  'Write a powerful introduction and analyze the character development of Bilbo Baggins.',
              teacher: 'Ms. Alice Wong',
              due: 'Tomorrow, 23:59',
              status: 'Due Tomorrow',
              statusColor: pending,
              icon: Icons.menu_book_rounded,
            ),
            _buildHomeworkCard(
              subject: 'Science',
              title: 'Solar System Project',
              desc:
                  'Create a 3D model or digital presentation of the solar system with labeled planets.',
              teacher: 'Mr. David Lee',
              due: 'In 5 days',
              status: 'Pending',
              statusColor: accent,
              icon: Icons.science_rounded,
            ),
            const SizedBox(height: 100), // bottom padding for curved nav
          ]),
        ),
      ],
    );
  }

  Widget _buildStudentHeader() {
    return Bounceable(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [accent, primary]),
              ),
              child: const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alex's Assignments",
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Grade 4 • Oakwood Primary',
                    style: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: primary, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Bounceable(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, const Color(0xFF1A5A9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Progress',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '70%',
                    style: GoogleFonts.inter(
                      color: success,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '7 of 10 assignments completed',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: 0.7,
                minHeight: 14,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                valueColor:  AlwaysStoppedAnimation(success),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // You can open full search page or show bottom sheet with search
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _buildSearchBottomSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: accent, size: 26),
            const SizedBox(width: 12),
            Text(
              'Search assignments...',
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search by subject, title, teacher...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF4A90E2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F6F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // You can show recent searches or results here
                    Text(
                      "Recent searches",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // ... list of chips or dummy results
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusFilters() {
    final filters = ['All', 'Pending', 'Completed', 'Overdue'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final f = filters[i];
          final isActive = f == 'All';
          return Bounceable(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: isActive ? accent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isActive)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Text(
                f,
                style: GoogleFonts.inter(
                  color: isActive ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String desc,
    required String teacher,
    required String due,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Bounceable(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _buildHomeworkDetailSheet(
            subject,
            title,
            desc,
            teacher,
            due,
            status,
            statusColor,
            icon,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor, statusColor.withValues(alpha: 0.6)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: accent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        subject.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE8EEF5), thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: accent.withValues(alpha: 0.15),
                            child: Icon(
                              Icons.person_rounded,
                              size: 16,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            teacher,
                            style: GoogleFonts.inter(
                              color: Colors.grey[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'View Details',
                            style: GoogleFonts.inter(
                              color: accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: accent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkDetailSheet(
    String subject,
    String title,
    String desc,
    String teacher,
    String due,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 52,
                height: 5.5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(icon, color: statusColor, size: 32),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: statusColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: primary,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildDetailRow(
                      Icons.calendar_today_rounded,
                      "Due Date",
                      due,
                      statusColor,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      Icons.person_rounded,
                      "Teacher",
                      teacher,
                      accent,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Instructions",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Attachments / Resources",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Placeholder for files / links
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            color: accent,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Worksheet_Page42.pdf",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(Icons.download_rounded, color: accent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: Bounceable(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Mark as Reviewed",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
