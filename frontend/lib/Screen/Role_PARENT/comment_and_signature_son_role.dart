import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart'; // Adjust path if needed

class ParentSignatureScreen extends StatefulWidget {
  const ParentSignatureScreen({super.key});

  @override
  State<ParentSignatureScreen> createState() => _ParentSignatureScreenState();
}

class _ParentSignatureScreenState extends State<ParentSignatureScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Premium Palette
  final Color primaryColor = const Color(0xFF0D3B66);
  final Color backgroundLight = const Color(0xFFF3F6F8);
  final Color accentBlue = const Color(0xFF4A90E2);
  final Color coralAccent = const Color(0xFFFF6B6B);
  final Color tealAccent = const Color(0xFF50E3C2);

  // List of screens for the navigation
  late final List<Widget> _screens = [
    _buildSignatureFormContent(), // Tab 0: Current Task
    Center(
      child: Text(
        "Document History",
        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        "Messages",
        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      // App bar only shows on the Signature tab
      appBar: _pageIndex == 0
          ? AppBar(
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
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                ),
              ),
              title: Column(
                children: [
                  Text(
                    'Comments & Signature',
                    style: GoogleFonts.outfit(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Step 2 of 2',
                    style: GoogleFonts.inter(
                      color: accentBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.draw_rounded, size: 28, color: Colors.white),
          Icon(Icons.history_edu_rounded, size: 28, color: Colors.white),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 28,
            color: Colors.white,
          ),
          Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
        ],
        color: primaryColor,
        buttonBackgroundColor: accentBlue,
        backgroundColor: backgroundLight,
        animationCurve: Curves.easeInOutBack,
        animationDuration: const Duration(milliseconds: 350),
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }

  // --- Main Content: Signature Form ---
  Widget _buildSignatureFormContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.content_paste_search_rounded,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Document Overview',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDocumentCard(),
          const SizedBox(height: 32),
          Text(
            'Comments to Teacher',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildCommentField(),
          const SizedBox(height: 32),
          _buildSignatureHeader(),
          const SizedBox(height: 12),
          _buildSignaturePad(),
          const SizedBox(height: 20),
          _buildLegalDisclaimer(),
          const SizedBox(height: 40),
          _buildActionButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildDocumentCard() {
    return Bounceable(
      onTap: () => _showDocumentDetail(),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_rounded,
                color: accentBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: coralAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'PENDING SIGNATURE',
                      style: GoogleFonts.inter(
                        color: coralAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Progress Report - Term 1',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Published: 12 Oct 2023',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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

  Widget _buildCommentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        maxLines: 4,
        style: GoogleFonts.inter(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Enter any remarks, feedback, or queries...',
          hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: accentBlue.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSignatureHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Parent Signature',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Bounceable(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.refresh_rounded, size: 14, color: primaryColor),
                const SizedBox(width: 4),
                Text(
                  'Refresh',
                  style: GoogleFonts.inter(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignaturePad() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.draw_rounded, color: Colors.grey.shade300, size: 60),
                const SizedBox(height: 12),
                Text(
                  'Please sign in this area',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.touch_app_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalDisclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.verified_user_rounded, color: tealAccent, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'By providing this signature, I verify that I have read and reviewed the contents of this academic progress report.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Bounceable(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Submit Document',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Bounceable(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDocumentDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
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
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: accentBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        color: accentBlue,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Progress Report - Term 1',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: coralAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'PENDING SIGNATURE',
                        style: GoogleFonts.inter(
                          color: coralAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildDocInfoRow(
                          Icons.calendar_today_rounded,
                          'Published Date',
                          '12 Oct 2023',
                          accentBlue,
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 16),
                        _buildDocInfoRow(
                          Icons.person_rounded,
                          'Student',
                          'Alex Johnson',
                          tealAccent,
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 16),
                        _buildDocInfoRow(
                          Icons.school_rounded,
                          'Class',
                          'Grade 10 - Room B',
                          const Color(0xFFB86DFF),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 16),
                        _buildDocInfoRow(
                          Icons.assignment_rounded,
                          'Document Type',
                          'Academic Progress Report',
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
                        Text(
                          'Summary',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'This report covers academic performance, attendance records, and teacher evaluations for Term 1. Please review all sections carefully before signing.',
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
                          'Back to Sign',
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

  Widget _buildDocInfoRow(
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
}
