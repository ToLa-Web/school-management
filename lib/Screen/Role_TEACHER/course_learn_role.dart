import 'package:flutter/material.dart';

class TeacherCourseScreen extends StatelessWidget {
  const TeacherCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCourseCard(
                    context,
                    title: "Mathematics - Grade 10",
                    level: "Secondary",
                    studentCount: "42 students",
                    progress: 0.75,
                    percentText: "75%",
                  ),
                  _buildCourseCard(
                    context,
                    title: "Physics - Grade 12",
                    level: "Secondary",
                    studentCount: "38 students",
                    progress: 0.45,
                    percentText: "45%",
                  ),
                  _buildCourseCard(
                    context,
                    title: "Khmer Language - Grade 5",
                    level: "Primary",
                    studentCount: "30 students",
                    progress: 0.90,
                    percentText: "90%",
                  ),
                  const SizedBox(
                    height: 100,
                  ), // Space for the bottom navigation curve
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with Back button and Filter
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleIcon(Icons.arrow_back_ios_new),
          const Text(
            "My Courses",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3673),
            ),
          ),
          _buildCircleIcon(Icons.tune), // Filter icon
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),

      child: Icon(icon, size: 18, color: const Color(0xFF1A3673)),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search courses...",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  // Individual Course Card
  Widget _buildCourseCard(
    BuildContext context, {
    required String title,
    required String level,
    required String studentCount,
    required double progress,
    required String percentText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Color(0xFF1A3673),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    studentCount,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Course Progress",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                percentText,
                style: const TextStyle(
                  color: Color(0xFF1A3673),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF0F0F0),
            color: const Color(0xFF1A3673),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(Icons.description, "Materials"),
              _buildActionButton(Icons.assignment, "Homework"),
              _buildActionButton(Icons.person_search, "Student List"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1A3673), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
