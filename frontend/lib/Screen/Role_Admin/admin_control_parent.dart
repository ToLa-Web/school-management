
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminControlParent extends StatefulWidget {
  const AdminControlParent({super.key});

  @override
  State<AdminControlParent> createState() => _AdminControlParentState();
}

class _AdminControlParentState extends State<AdminControlParent> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Color Constants
  static const Color primaryBlue = Color(0xFF1A1FB1);
  static const Color scaffoldBg = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      // Maintains page state using IndexedStack
      body: IndexedStack(
        index: _pageIndex,
        children: [
          _buildHomeContent(), // Main Parent Oversight Content
          const Center(child: Text("Users Screen")),
          const Center(child: Text("Analytics Screen")),
          const Center(child: Text("Settings Screen")),
        ],
      ),

      // --- CURVED NAVIGATION BAR ---
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.people, size: 30, color: Colors.white),
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: primaryBlue,
        buttonBackgroundColor: primaryBlue,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  // Refactored Dashboard Logic
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
            ),
            child: Column(
              children: [
                _buildHeaderTopRow(),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    _StatHeaderCard(
                      label: "សំណើសុំភ្ជាប់គណនី",
                      value: "១២",
                      icon: Icons.person_add_alt_1,
                      iconBg: Color(0xFFFFF9E7),
                      iconColor: Colors.orange,
                    ),
                    SizedBox(width: 15),
                    _StatHeaderCard(
                      label: "សកម្មភាពមាតាបិតា",
                      value: "៤៥",
                      icon: Icons.insights,
                      iconBg: Color(0xFFE8EAF6),
                      iconColor: Colors.indigo,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pending Requests
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _SectionHeader(
                  title: "សំណើដែលកំពុងរង់ចាំ",
                  indicatorColor: Colors.orange,
                  onViewAll: () {},
                ),
                const SizedBox(height: 15),
                const _ParentRequestCard(
                  name: "លោក សុខ ហេង",
                  childName: "សុខ ណារី",
                  statusLabel: "ភ្ជាប់គណនី",
                  statusColor: Colors.blue,
                ),
                const _ParentRequestCard(
                  name: "អ្នកស្រី ចាន់ ធារី",
                  childName: "គីម ឡុង",
                  statusLabel: "បច្ចុប្បន្នភាព",
                  statusColor: Colors.orange,
                ),
              ],
            ),
          ),

          // Issue Reports
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _SectionHeader(
                  title: "របាយការណ៍បញ្ហា",
                  indicatorColor: Colors.red,
                  onViewAll: () {},
                ),
                const SizedBox(height: 15),
                const _ParentIssueTile(
                  title: "បញ្ហាចូលប្រព័ន្ធមិនបាន",
                  subtitle: "ដោយ៖ លោក វណ្ណៈ (ឪពុក សុភ័ក្ត្រ)",
                  timeText: "២ នាទីមុន",
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.red,
                  iconBg: Color(0xFFFFEBEE),
                ),
                const _ParentIssueTile(
                  title: "សួរអំពីកាលវិភាគប្រឡង",
                  subtitle: "ដោយ៖ អ្នកស្រី ម៉ាលី (ម្តាយ ធីតា)",
                  timeText: "១ ម៉ោងមុន",
                  icon: Icons.help_outline,
                  iconColor: Colors.orange,
                  iconBg: Color(0xFFFFF3E0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Push content above the nav bar
        ],
      ),
    );
  }

  Widget _buildHeaderTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        const Column(
          children: [
            Text(
              "គ្រប់គ្រងមាតាបិតា",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ទិដ្ឋភាពទូទៅនៃមាតាបិតា",
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        const Icon(Icons.search, color: Colors.white),
      ],
    );
  }
}

// --- REUSABLE COMPONENTS ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color indicatorColor;
  final VoidCallback onViewAll;

  const _SectionHeader({
    required this.title,
    required this.indicatorColor,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, color: indicatorColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            "មើលទាំងអស់",
            style: TextStyle(color: Color(0xFF1A1FB1), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _StatHeaderCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconBg, iconColor;

  const _StatHeaderCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1A1FB1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentRequestCard extends StatelessWidget {
  final String name, childName, statusLabel;
  final Color statusColor;

  const _ParentRequestCard({
    required this.name,
    required this.childName,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFD4AF37),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        children: [
                          const TextSpan(text: "មាតាបិតារបស់៖ "),
                          TextSpan(
                            text: childName,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _actionBtn("អនុម័ត", const Color(0xFF1A1FB1), true),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionBtn("បដិសេធ", const Color(0xFFF1F2F6), false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color bg, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ParentIssueTile extends StatelessWidget {
  final String title, subtitle, timeText;
  final IconData icon;
  final Color iconColor, iconBg;

  const _ParentIssueTile({
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      timeText,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
