import 'dart:async'; // Add this import for Timer

import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Edit-Profile/parent_edit_profile.dart';
import 'package:tamdansers/Screen/Role_PARENT/attendance_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/comment_and_signature_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/events_news_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/homework_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/result_monthly_son_role.dart';
import 'package:tamdansers/services/api_service.dart';

// --- MAIN WRAPPER WITH NAVIGATION ---
class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define screen views
  final List<Widget> _screens = [
    const ParentHomeContent(),
    const ParentCoursesTab(),
    const ParentMessagesTab(),
    const ParentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 28, color: Colors.white),
          Icon(Icons.calendar_month_outlined, size: 28, color: Colors.white),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 28,
            color: Colors.white,
          ),
          Icon(Icons.settings_outlined, size: 28, color: Colors.white),
        ],
        color: const Color(0xFF0D3B66),
        buttonBackgroundColor: const Color(0xFF4A90E2),
        backgroundColor: const Color(0xFFF3F6F8),
        animationCurve: Curves.easeInOutBack,
        animationDuration: const Duration(milliseconds: 350),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}

// --- DASHBOARD CONTENT ---
class ParentHomeContent extends StatefulWidget {
  const ParentHomeContent({super.key});

  @override
  State<ParentHomeContent> createState() => _ParentHomeContentState();
}

class _ParentHomeContentState extends State<ParentHomeContent>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _userName = '';
  String _userEmail = '';
  int _currentTaskIndex = 0;
  int _currentExamIndex = 0;

  // Animation Controllers
  late AnimationController _taskCardAnimationController;
  late AnimationController _examCardAnimationController;
  late Animation<double> _taskCardScaleAnimation;
  late Animation<double> _examCardScaleAnimation;
  late Animation<double> _taskCardFadeAnimation;
  late Animation<double> _examCardFadeAnimation;

  // Auto-play timers
  late Timer _taskCarouselTimer;
  late Timer _examCarouselTimer;

  // Palette
  final Color primaryColor = const Color(0xFF0D3B66);
  final Color accentBlue = const Color(0xFF4A90E2);
  final Color backgroundLight = const Color(0xFFF3F6F8);
  final Color coralAccent = const Color(0xFFFF6B6B);
  final Color tealAccent = const Color(0xFF50E3C2);

  // Carousel controllers
  final CarouselSliderController _taskCarouselController =
      CarouselSliderController();
  final CarouselSliderController _examCarouselController =
      CarouselSliderController();

  // Sample homework data
  final List<Map<String, dynamic>> homeworkList = [
    {
      'subject': 'History',
      'title': 'The French Revolution:\nNarrative Essay',
      'deadline': 'Due Tomorrow',
      'color': Color(0xFFFFB75E),
      'icon': Icons.access_time_rounded,
    },
    {
      'subject': 'Chemistry',
      'title': 'Acid-Base\nLab Report',
      'deadline': 'Due Tomorrow',
      'color': Color(0xFF50E3C2),
      'icon': Icons.calendar_today_rounded,
    },
    {
      'subject': 'Mathematics',
      'title': 'Calculus\nProblem Set',
      'deadline': 'Due in 3 days',
      'color': Color(0xFF4A90E2),
      'icon': Icons.access_time_rounded,
    },
    {
      'subject': 'Physics',
      'title': 'Newton\'s Laws\nLab Report',
      'deadline': 'Due Friday',
      'color': Color(0xFFB86DFF),
      'icon': Icons.calendar_today_rounded,
    },
  ];

  // Sample exam data
  final List<Map<String, dynamic>> examList = [
    {
      'title': 'Advanced Mathematics',
      'timeLeft': '2 days left',
      'date': 'Mon, Oct 12',
      'image': 'assets/images/MATH.jpg',
    },
    {
      'title': 'General Science',
      'timeLeft': 'Next week',
      'date': 'Fri, Oct 16',
      'image': 'assets/images/2011.jpg',
    },
    {
      'title': 'English Literature',
      'timeLeft': '5 days left',
      'date': 'Wed, Oct 14',
      'image': 'assets/images/ENGLISH.jpg',
    },
    {
      'title': 'History Final',
      'timeLeft': '1 week',
      'date': 'Mon, Oct 19',
      'image': 'assets/images/HISTORY.jpg',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Initialize animation controllers
    _taskCardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _examCardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _taskCardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _taskCardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _examCardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _examCardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _taskCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taskCardAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _examCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _examCardAnimationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animations
    _taskCardAnimationController.forward();
    _examCardAnimationController.forward();

    // Start auto-play timers (optional - carousel already has built-in auto-play)
    // _startTaskCarouselTimer();
    // _startExamCarouselTimer();
  }

  // ignore: unused_element
  void _startTaskCarouselTimer() {
    _taskCarouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        int nextIndex = (_currentTaskIndex + 1) % homeworkList.length;
        _taskCarouselController.animateToPage(nextIndex);
        setState(() {
          _currentTaskIndex = nextIndex;
          _animateTaskCardChange();
        });
      }
    });
  }

  // ignore: unused_element
  void _startExamCarouselTimer() {
    _examCarouselTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        int nextIndex = (_currentExamIndex + 1) % examList.length;
        _examCarouselController.animateToPage(nextIndex);
        setState(() {
          _currentExamIndex = nextIndex;
          _animateExamCardChange();
        });
      }
    });
  }

  @override
  void dispose() {
    _taskCardAnimationController.dispose();
    _examCardAnimationController.dispose();
    _taskCarouselTimer.cancel();
    _examCarouselTimer.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();
    final name = await apiService.getUserName();
    final email = await apiService.getUserEmail();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Parent';
        _userEmail = email ?? '';
      });
    }
  }

  // Animate cards when index changes
  void _animateTaskCardChange() {
    _taskCardAnimationController.reset();
    _taskCardAnimationController.forward();
  }

  void _animateExamCardChange() {
    _examCardAnimationController.reset();
    _examCardAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildParentHeader(),
            const SizedBox(height: 25),
            _buildStudentProfileCard(context, _userName, _userEmail),
            const SizedBox(height: 25),
            _buildAttendanceStatusCard(),
            const SizedBox(height: 30),
            _buildParentGridMenu(context),
            const SizedBox(height: 30),
            _buildSectionTitle("Quick Actions", actionText: "Manage"),
            const SizedBox(height: 20),
            _buildQuickActions(context),
            const SizedBox(height: 35),
            _buildSectionHeader("Upcoming Tasks", actionText: "View All"),
            const SizedBox(height: 20),
            _buildAnimatedTaskCarousel(),
            const SizedBox(height: 20),
            _buildCarouselIndicators(
              itemCount: homeworkList.length,
              currentIndex: _currentTaskIndex,
              carouselController: _taskCarouselController,
              onTap: (index) {
                setState(() {
                  _currentTaskIndex = index;
                  _animateTaskCardChange();
                });
              },
            ),
            const SizedBox(height: 35),
            _buildSectionHeader("Upcoming Exams", actionText: "View All"),
            const SizedBox(height: 20),
            _buildAnimatedExamCarousel(),
            const SizedBox(height: 20),
            _buildCarouselIndicators(
              itemCount: examList.length,
              currentIndex: _currentExamIndex,
              carouselController: _examCarouselController,
              onTap: (index) {
                setState(() {
                  _currentExamIndex = index;
                  _animateExamCardChange();
                });
              },
            ),
            const SizedBox(height: 35),
            _buildSectionHeader("Teacher Feedback", hasNew: true),
            const SizedBox(height: 20),
            _buildTeacherFeedbackCard(),
            const SizedBox(height: 30),
            _buildMessageTeacherCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- ANIMATED CAROUSEL METHODS ---

  Widget _buildAnimatedTaskCarousel() {
    return AnimatedBuilder(
      animation: _taskCardAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _taskCardFadeAnimation,
          child: ScaleTransition(scale: _taskCardScaleAnimation, child: child),
        );
      },
      child: CarouselSlider(
        carouselController: _taskCarouselController,
        options: CarouselOptions(
          height: 220,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOutCubic,
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _currentTaskIndex = index;
              _animateTaskCardChange();
            });
          },
        ),
        items: homeworkList.map((homework) {
          return Builder(
            builder: (BuildContext context) {
              return _buildHomeworkCard(
                subject: homework['subject'],
                title: homework['title'],
                deadline: homework['deadline'],
                dotColor: homework['color'],
                isIconCalendar:
                    homework['icon'] == Icons.calendar_today_rounded,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedExamCarousel() {
    return AnimatedBuilder(
      animation: _examCardAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _examCardFadeAnimation,
          child: ScaleTransition(scale: _examCardScaleAnimation, child: child),
        );
      },
      child: CarouselSlider(
        carouselController: _examCarouselController,
        options: CarouselOptions(
          height: 280,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 6),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOutCubic,
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _currentExamIndex = index;
              _animateExamCardChange();
            });
          },
        ),
        items: examList.map((exam) {
          return Builder(
            builder: (BuildContext context) {
              return _buildExamCard(
                exam['title'],
                exam['timeLeft'],
                exam['date'],
                exam['image'],
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarouselIndicators({
    required int itemCount,
    required int currentIndex,
    required CarouselSliderController carouselController,
    required Function(int) onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () {
            carouselController.animateToPage(index);
            onTap(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: currentIndex == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentIndex == index
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.2),
            ),
          ),
        );
      }),
    );
  }

  // --- UI HELPER METHODS (with added animations) ---

  Widget _buildParentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Icon(
            Icons.family_restroom_rounded,
            color: primaryColor,
            size: 30,
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Text(
            "Parent Portal",
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Bounceable(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.5, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticInOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: coralAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentProfileCard(
    BuildContext context,
    String userName,
    String userEmail,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Bounceable(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ParentEditProfileScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                    width: 3,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : 'John Doe',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Student ID: STU-84920",
                      style: GoogleFonts.inter(
                        color: accentBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tealAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "TODAY's STATUS",
                    style: GoogleFonts.inter(
                      color: tealAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Arrived Safely",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Scanned at 08:30 AM (On time)",
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildAnimatedGridItem(
          0,
          context,
          Icons.menu_book_rounded,
          "Homework",
          coralAccent,
          const ParentHomeworkScreen(),
        ),
        _buildAnimatedGridItem(
          1,
          context,
          Icons.fact_check_rounded,
          "Attendance",
          tealAccent,
          const ParentAttendanceMonitor(),
        ),
        _buildAnimatedGridItem(
          2,
          context,
          Icons.rate_review_rounded,
          "Feedback",
          const Color(0xFFB86DFF),
          const ParentSignatureScreen(),
        ),
        _buildAnimatedGridItem(
          3,
          context,
          Icons.event_available_rounded,
          "Events",
          const Color(0xFFFFB75E),
          const SchoolNewsEventsScreen(),
        ),
      ],
    );
  }

  Widget _buildAnimatedGridItem(
    int index,
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget screen,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Bounceable(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAnimatedActionItem(
          0,
          context,
          Icons.check_circle_outline_rounded,
          "Monitor",
          tealAccent,
          const ParentAttendanceMonitor(),
        ),
        _buildAnimatedActionItem(
          1,
          context,
          Icons.auto_graph_rounded,
          "Results",
          accentBlue,
          const StudentReportScreen(),
        ),
        _buildAnimatedActionItem(
          2,
          context,
          Icons.campaign_outlined,
          "News",
          coralAccent,
          const SchoolNewsEventsScreen(),
        ),
      ],
    );
  }

  Widget _buildAnimatedActionItem(
    int index,
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget destination,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Bounceable(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String deadline,
    required Color dotColor,
    bool isIconCalendar = false,
  }) {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParentHomeworkScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: dotColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subject.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: dotColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primaryColor,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  isIconCalendar
                      ? Icons.calendar_today_rounded
                      : Icons.access_time_rounded,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  deadline,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(
    String title,
    String timeLeft,
    String date,
    String assetImage,
  ) {
    return Bounceable(
      onTap: () => _showExamDetailSheet(title, timeLeft, date, assetImage),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    assetImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: primaryColor.withValues(alpha: 0.1),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: primaryColor.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: timeLeft.contains("day")
                              ? const Color(0xFFFFB75E).withValues(alpha: 0.15)
                              : accentBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          timeLeft,
                          style: GoogleFonts.inter(
                            color: timeLeft.contains("day")
                                ? const Color(0xFFE89B3A)
                                : accentBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: backgroundLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Colors.grey,
                        ),
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

  Widget _buildSectionHeader(
    String title, {
    bool hasNew = false,
    String? actionText,
  }) {
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-10 * (1 - value), 0),
                child: child,
              ),
            );
          },
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
        if (hasNew) ...[
          const SizedBox(width: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: coralAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "NEW",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
        const Spacer(),
        if (actionText != null)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(10 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Text(
              actionText,
              style: GoogleFonts.inter(
                color: accentBlue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {String? actionText}) {
    return _buildSectionHeader(title, actionText: actionText);
  }

  Widget _buildTeacherFeedbackCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Bounceable(
        onTap: () => _showTeacherFeedbackDetail(),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accentBlue, tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-vector/cheerful-young-woman-with-blonde-hair_1308-133504.jpg?semt=ais_hybrid&w=740&q=80',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mrs. Sarah Jenkins",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Homeroom Teacher",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "\"Alex showed excellent leadership during today's class discussion...\"",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTeacherCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Bounceable(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Messaging feature coming soon!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: accentBlue,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: accentBlue,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: accentBlue.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Message Teachers",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Start a conversation",
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: accentBlue,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExamDetailSheet(
    String title,
    String timeLeft,
    String date,
    String assetImage,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  ClipRRect(
                    child: Image.asset(
                      assetImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: primaryColor.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: primaryColor.withValues(alpha: 0.4),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: timeLeft.contains("day")
                                    ? const Color(0xFFFFB75E).withValues(alpha: 0.15)
                                    : accentBlue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                timeLeft.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: timeLeft.contains("day")
                                      ? const Color(0xFFE89B3A)
                                      : accentBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              date,
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F6F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              _buildExamInfoRow(
                                Icons.access_time_rounded,
                                'Duration',
                                '2 Hours',
                                accentBlue,
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFFE2E8F0)),
                              const SizedBox(height: 16),
                              _buildExamInfoRow(
                                Icons.room_rounded,
                                'Location',
                                'Examination Hall A',
                                tealAccent,
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFFE2E8F0)),
                              const SizedBox(height: 16),
                              _buildExamInfoRow(
                                Icons.person_rounded,
                                'Examiner',
                                'Department Faculty',
                                const Color(0xFFB86DFF),
                              ),
                              const SizedBox(height: 16),
                              const Divider(color: Color(0xFFE2E8F0)),
                              const SizedBox(height: 16),
                              _buildExamInfoRow(
                                Icons.description_rounded,
                                'Format',
                                'Written + MCQ',
                                const Color(0xFFFFB75E),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates_rounded,
                                    color: const Color(0xFFFFB75E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Preparation Tips',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Review all course materials, practice problems, and past exam papers. Ensure your child gets adequate rest the night before.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: Bounceable(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F6F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.inter(
                                        color: primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Bounceable(
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Reminder set for $title',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      backgroundColor: primaryColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentBlue,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentBlue.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.alarm_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Set Reminder',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamInfoRow(
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTeacherFeedbackDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Teacher Profile
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [accentBlue, tealAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-vector/cheerful-young-woman-with-blonde-hair_1308-133504.jpg?semt=ais_hybrid&w=740&q=80',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Mrs. Sarah Jenkins',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Homeroom Teacher',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Full Feedback
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              color: accentBlue,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Today's Feedback",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Alex showed excellent leadership during today's class discussion. He was attentive, participated actively, and helped other students understand complex topics. His homework submission was on time and well-organized. I'm very pleased with his progress this term.",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: primaryColor,
                            fontStyle: FontStyle.italic,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Posted 2 hours ago',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Behavior Summary
                  Text(
                    'Behavior Summary',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBehaviorChip(
                          'Leadership',
                          Icons.star_rounded,
                          const Color(0xFFFFB75E),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBehaviorChip(
                          'Participation',
                          Icons.record_voice_over_rounded,
                          tealAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBehaviorChip(
                          'Punctuality',
                          Icons.schedule_rounded,
                          accentBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBehaviorChip(
                          'Teamwork',
                          Icons.groups_rounded,
                          const Color(0xFFB86DFF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Bounceable(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Close',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildBehaviorChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PARENT COURSES TAB – Children's Academic Overview
// =============================================================================
class ParentCoursesTab extends StatefulWidget {
  const ParentCoursesTab({super.key});

  @override
  State<ParentCoursesTab> createState() => _ParentCoursesTabState();
}

class _ParentCoursesTabState extends State<ParentCoursesTab> {
  int _selectedChildIndex = 0;

  final List<Map<String, dynamic>> _children = [
    {
      'name': 'Sopheak',
      'grade': 'Grade 12-A',
      'avatar': '👦',
      'gpa': 3.72,
      'courses': [
        {
          'title': 'Mathematics',
          'teacher': 'Mr. Johnson',
          'grade': 'A',
          'score': 92,
          'progress': 0.82,
          'color': const Color(0xFF4A90E2),
          'icon': Icons.calculate_rounded,
          'status': 'On Track',
          'nextExam': 'Mar 5',
        },
        {
          'title': 'Physics',
          'teacher': 'Ms. Williams',
          'grade': 'B+',
          'score': 85,
          'progress': 0.68,
          'color': const Color(0xFFFFB75E),
          'icon': Icons.bolt_rounded,
          'status': 'Needs Attention',
          'nextExam': 'Mar 8',
        },
        {
          'title': 'Chemistry',
          'teacher': 'Dr. Smith',
          'grade': 'A-',
          'score': 89,
          'progress': 0.75,
          'color': const Color(0xFF50E3C2),
          'icon': Icons.science_rounded,
          'status': 'On Track',
          'nextExam': 'Mar 12',
        },
        {
          'title': 'English Literature',
          'teacher': 'Ms. Taylor',
          'grade': 'A',
          'score': 94,
          'progress': 0.90,
          'color': const Color(0xFF6C5CE7),
          'icon': Icons.auto_stories_rounded,
          'status': 'Excellent',
          'nextExam': 'Mar 3',
        },
        {
          'title': 'Computer Science',
          'teacher': 'Ms. Lee',
          'grade': 'B',
          'score': 80,
          'progress': 0.55,
          'color': const Color(0xFF0D3B66),
          'icon': Icons.computer_rounded,
          'status': 'Needs Attention',
          'nextExam': 'Mar 15',
        },
      ],
    },
    {
      'name': 'Dara',
      'grade': 'Grade 9-B',
      'avatar': '👧',
      'gpa': 3.85,
      'courses': [
        {
          'title': 'Mathematics',
          'teacher': 'Mr. Brown',
          'grade': 'A+',
          'score': 97,
          'progress': 0.95,
          'color': const Color(0xFF4A90E2),
          'icon': Icons.calculate_rounded,
          'status': 'Excellent',
          'nextExam': 'Mar 6',
        },
        {
          'title': 'Biology',
          'teacher': 'Dr. Chen',
          'grade': 'A',
          'score': 91,
          'progress': 0.85,
          'color': const Color(0xFFF95738),
          'icon': Icons.biotech_rounded,
          'status': 'On Track',
          'nextExam': 'Mar 10',
        },
        {
          'title': 'Art & Design',
          'teacher': 'Ms. Davis',
          'grade': 'A+',
          'score': 98,
          'progress': 0.97,
          'color': const Color(0xFFB86DFF),
          'icon': Icons.palette_rounded,
          'status': 'Excellent',
          'nextExam': 'Mar 14',
        },
      ],
    },
  ];

  Map<String, dynamic> get _selectedChild => _children[_selectedChildIndex];
  List<Map<String, dynamic>> get _courses =>
      List<Map<String, dynamic>>.from(_selectedChild['courses']);

  double get _avgScore {
    final scores = _courses.map((c) => c['score'] as int).toList();
    return scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) / scores.length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF6FB1FC)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Academic Overview',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    Text(
                      "Your children's progress",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Child Selector ──
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                final isSelected = index == _selectedChildIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Bounceable(
                    onTap: () => setState(() => _selectedChildIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D3B66)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? const Color(0xFF0D3B66).withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            child['avatar'] as String,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                child['name'] as String,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF0D3B66),
                                ),
                              ),
                              Text(
                                child['grade'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── GPA & Average Score Card ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D3B66).withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // GPA circle
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            value: (_selectedChild['gpa'] as double) / 4.0,
                            strokeWidth: 7,
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF50E3C2),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Center(
                          child: Text(
                            (_selectedChild['gpa'] as double).toStringAsFixed(
                              1,
                            ),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GPA: ${(_selectedChild['gpa'] as double).toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Avg Score: ${_avgScore.toStringAsFixed(0)}%',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_courses.length} courses enrolled',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _avgScore >= 90
                          ? const Color(0xFF50E3C2)
                          : _avgScore >= 80
                          ? const Color(0xFF4A90E2)
                          : const Color(0xFFFFB75E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _avgScore >= 90
                          ? 'A'
                          : _avgScore >= 80
                          ? 'B+'
                          : 'B',
                      style: GoogleFonts.outfit(
                        color: _avgScore >= 90
                            ? const Color(0xFF0D3B66)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Section title ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Course Details",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D3B66),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Course Cards ──
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return _buildParentCourseCard(course);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentCourseCard(Map<String, dynamic> course) {
    final Color accent = course['color'] as Color;
    final String status = course['status'] as String;

    Color statusColor;
    switch (status) {
      case 'Excellent':
        statusColor = const Color(0xFF50E3C2);
        break;
      case 'On Track':
        statusColor = const Color(0xFF4A90E2);
        break;
      default:
        statusColor = const Color(0xFFF95738);
    }

    return Bounceable(
      onTap: () => _showCourseDetail(context, course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      course['icon'] as IconData,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course['teacher'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Grade badge
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        course['grade'] as String,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: accent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  // Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFFFB75E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course['score']}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Next Exam
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_rounded,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course['nextExam'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Progress
                  SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Text(
                          '${((course['progress'] as double) * 100).toInt()}%',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 3),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: course['progress'] as double,
                            minHeight: 5,
                            backgroundColor: const Color(0xFFF3F6F8),
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCourseDetail(BuildContext context, Map<String, dynamic> course) {
    final Color accent = course['color'] as Color;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    course['icon'] as IconData,
                    size: 42,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course['teacher']} · Score: ${course['score']}%',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course['grade'] as String,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Info Tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildInfoTile(
                    'Status',
                    course['status'] as String,
                    Icons.trending_up_rounded,
                    accent,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoTile(
                    'Next Exam',
                    course['nextExam'] as String,
                    Icons.event_rounded,
                    const Color(0xFFF95738),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoTile(
                    'Progress',
                    '${((course['progress'] as double) * 100).toInt()}%',
                    Icons.bar_chart_rounded,
                    const Color(0xFF50E3C2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildActionButton(
                    'Contact Teacher',
                    Icons.message_rounded,
                    const Color(0xFF4A90E2),
                    () {
                      Navigator.pop(context);
                      // Navigate to messages
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(
                    'View Homework',
                    Icons.assignment_rounded,
                    const Color(0xFFFFB75E),
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(
                    'Attendance Report',
                    Icons.fact_check_rounded,
                    const Color(0xFF50E3C2),
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: const Color(0xFF0D3B66),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: const Color(0xFF0D3B66),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PARENT MESSAGES TAB
// =============================================================================
class ParentMessagesTab extends StatefulWidget {
  const ParentMessagesTab({super.key});

  @override
  State<ParentMessagesTab> createState() => _ParentMessagesTabState();
}

class _ParentMessagesTabState extends State<ParentMessagesTab>
    with SingleTickerProviderStateMixin {
  late TabController _msgTabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Mr. Johnson',
      'subject': 'Math Teacher – Grade 12-A',
      'message': "Your child did great on today's quiz!",
      'time': '5m ago',
      'unread': 2,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF4A90E2),
      'type': 'teacher',
    },
    {
      'name': 'Ms. Williams',
      'subject': 'Physics Teacher – Grade 11-B',
      'message': 'Homework submission reminder for Friday.',
      'time': '20m ago',
      'unread': 1,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFFFFB75E),
      'type': 'teacher',
    },
    {
      'name': 'Parent Group 12-A',
      'subject': '25 parents',
      'message': 'Amy: When is the next parent meeting?',
      'time': '1h ago',
      'unread': 8,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFFB86DFF),
      'type': 'group',
    },
    {
      'name': 'Dr. Smith',
      'subject': 'Chemistry Teacher',
      'message': 'Lab report feedback is shared.',
      'time': '2h ago',
      'unread': 0,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFF50E3C2),
      'type': 'teacher',
    },
    {
      'name': 'School Admin',
      'subject': 'Administration',
      'message': 'Tuition payment receipt attached.',
      'time': '3h ago',
      'unread': 1,
      'online': false,
      'avatar': Icons.admin_panel_settings_rounded,
      'color': const Color(0xFF0D3B66),
      'type': 'admin',
    },
    {
      'name': 'Parent Group 9-B',
      'subject': '18 parents',
      'message': 'David: Sports day is next week!',
      'time': '5h ago',
      'unread': 3,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFFF95738),
      'type': 'group',
    },
    {
      'name': 'Ms. Taylor',
      'subject': 'English Teacher',
      'message': 'Book report deadline extended to March 10.',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFF6C5CE7),
      'type': 'teacher',
    },
    {
      'name': 'Ms. Lee',
      'subject': 'Computer Science Teacher',
      'message': 'Project presentation schedule is out.',
      'time': 'Yesterday',
      'unread': 0,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF4A4A4A),
      'type': 'teacher',
    },
  ];

  List<Map<String, dynamic>> _filterByTab(int tabIndex) {
    List<Map<String, dynamic>> list;
    if (tabIndex == 0) {
      list = _conversations;
    } else if (tabIndex == 1) {
      list = _conversations
          .where((c) => c['type'] == 'teacher' || c['type'] == 'admin')
          .toList();
    } else {
      list = _conversations.where((c) => c['type'] == 'group').toList();
    }
    if (_searchQuery.isEmpty) return list;
    return list
        .where(
          (c) =>
              c['name'].toString().toLowerCase().contains(_searchQuery) ||
              c['message'].toString().toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  int get _totalUnread =>
      _conversations.fold(0, (sum, c) => sum + (c['unread'] as int));

  @override
  void initState() {
    super.initState();
    _msgTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _msgTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    Text(
                      '$_totalUnread unread messages',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Bounceable(
                  onTap: () => _showComposeSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D3B66),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Tab Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _msgTabController,
                onTap: (_) => setState(() {}),
                indicator: BoxDecoration(
                  color: const Color(0xFF0D3B66),
                  borderRadius: BorderRadius.circular(14),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(14),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('All'),
                        if (_totalUnread > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _msgTabController.index == 0
                                  ? const Color(0xFFF95738)
                                  : const Color(0xFFF95738).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_totalUnread',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _msgTabController.index == 0
                                    ? Colors.white
                                    : const Color(0xFFF95738),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Tab(text: 'Teachers'),
                  const Tab(text: 'Groups'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                style: GoogleFonts.inter(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Online Now ──
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _conversations
                  .where((c) => c['online'] == true)
                  .length,
              itemBuilder: (context, index) {
                final onlineUsers = _conversations
                    .where((c) => c['online'] == true)
                    .toList();
                final user = onlineUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  user['color'] as Color,
                                  (user['color'] as Color).withValues(alpha: 0.6),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (user['color'] as Color).withValues(alpha: 
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              user['avatar'] as IconData,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF50E3C2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF3F6F8),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: Text(
                          (user['name'] as String).split(' ').last,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Conversations List ──
          Expanded(
            child: TabBarView(
              controller: _msgTabController,
              children: [
                _buildConversationList(_filterByTab(0)),
                _buildConversationList(_filterByTab(1)),
                _buildConversationList(_filterByTab(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList(List<Map<String, dynamic>> conversations) {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No conversations yet',
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conv = conversations[index];
        return _buildConversationTile(conv);
      },
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conv) {
    final int unread = conv['unread'] as int;
    final bool isOnline = conv['online'] as bool;
    final Color accent = conv['color'] as Color;
    final bool isGroup = conv['type'] == 'group';

    return Bounceable(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ParentChatDetailScreen(conversation: conv),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread > 0
              ? const Color(0xFF0D3B66).withValues(alpha: 0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: unread > 0
              ? Border.all(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.15),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isGroup ? Icons.groups_rounded : Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF50E3C2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv['name'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: unread > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15,
                            color: const Color(0xFF0D3B66),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conv['time'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: unread > 0
                              ? const Color(0xFF4A90E2)
                              : Colors.grey.shade400,
                          fontWeight: unread > 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conv['subject'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv['message'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: unread > 0
                                ? const Color(0xFF0D3B66)
                                : Colors.grey.shade500,
                            fontWeight: unread > 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF95738),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unread',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  void _showComposeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'New Message',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  style: GoogleFonts.inter(color: const Color(0xFF0D3B66)),
                  decoration: InputDecoration(
                    hintText: 'Search teacher or group...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _conversations.length,
                itemBuilder: (context, i) {
                  final c = _conversations[i];
                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        c['avatar'] as IconData,
                        color: c['color'] as Color,
                      ),
                    ),
                    title: Text(
                      c['name'] as String,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    subtitle: Text(
                      c['subject'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ParentChatDetailScreen(conversation: c),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PARENT CHAT DETAIL SCREEN
// =============================================================================
class ParentChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;
  const ParentChatDetailScreen({super.key, required this.conversation});

  @override
  State<ParentChatDetailScreen> createState() => _ParentChatDetailScreenState();
}

class _ParentChatDetailScreenState extends State<ParentChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! Thank you for reaching out.',
      'isMe': false,
      'time': '9:00 AM',
    },
    {
      'text': "Hi! I wanted to ask about my child's progress this month.",
      'isMe': true,
      'time': '9:02 AM',
    },
    {
      'text':
          'Your child has been doing very well. Scoring consistently above 85% in all tests.',
      'isMe': false,
      'time': '9:03 AM',
    },
    {
      'text': "That's wonderful to hear! Any areas where they could improve?",
      'isMe': true,
      'time': '9:05 AM',
    },
    {
      'text':
          'I noticed they could practice more problem-solving exercises. I will share some resources.',
      'isMe': false,
      'time': '9:06 AM',
    },
    {
      'text': 'Thank you so much! I really appreciate your support.',
      'isMe': true,
      'time': '9:08 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.conversation['color'] as Color;
    final bool isGroup = widget.conversation['type'] == 'group';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isGroup ? Icons.groups_rounded : Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.conversation['name'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF0D3B66),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.conversation['online'] == true
                              ? 'Online'
                              : widget.conversation['subject'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: widget.conversation['online'] == true
                                ? const Color(0xFF50E3C2)
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.phone_rounded,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'] as bool;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 18,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF0D3B66)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isMe ? 20 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['text'] as String,
                                style: GoogleFonts.inter(
                                  color: isMe
                                      ? Colors.white
                                      : const Color(0xFF0D3B66),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isMe) const SizedBox(width: 40),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.attach_file_rounded,
                    color: Color(0xFF0D3B66),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0D3B66),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Bounceable(
                  onTap: () {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'text': text,
                          'isMe': true,
                          'time': 'Now',
                        });
                        _messageController.clear();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
