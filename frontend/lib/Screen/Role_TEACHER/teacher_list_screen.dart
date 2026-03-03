import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/services/api_service.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});
  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  static const _orange = Color(0xFFF95738);
  static const _deepBlue = Color(0xFF0D3B66);
  static const _bg = Color(0xFFF3F6F8);
  final _api = ApiService();
  List<TeacherDto> _teachers = [];
  bool _isLoading = true;
  String _search = '';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _api.getTeachers();
      if (mounted) {
        setState(() {
          _teachers = list;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<TeacherDto> get _filtered {
    if (_search.isEmpty) return _teachers;
    final q = _search.toLowerCase();
    return _teachers
        .where(
          (t) =>
              t.fullName.toLowerCase().contains(q) ||
              (t.specialization ?? '').toLowerCase().contains(q) ||
              (t.email ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header row with back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: _deepBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Teachers',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: _deepBlue,
                        ),
                      ),
                      Text(
                        '${_teachers.length} teachers total',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: GoogleFonts.inter(fontSize: 15, color: _deepBlue),
                  decoration: InputDecoration(
                    hintText: 'Search by name, specialization...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No teachers found',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => _teacherCard(_filtered[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teacherCard(TeacherDto t) {
    final initials =
        '${t.firstName.isNotEmpty ? t.firstName[0] : ''}${t.lastName.isNotEmpty ? t.lastName[0] : ''}'
            .toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _orange.withValues(alpha: 0.12),
            child: Text(
              initials.isEmpty ? '?' : initials,
              style: GoogleFonts.outfit(
                color: _orange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.fullName,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _deepBlue,
                  ),
                ),
                const SizedBox(height: 3),
                if (t.specialization != null && t.specialization!.isNotEmpty)
                  Text(
                    t.specialization!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  [
                    t.email,
                    t.phone,
                  ].where((e) => e != null && e.isNotEmpty).join(' • '),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: t.isActive ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              t.isActive ? 'Active' : 'Inactive',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: t.isActive ? Colors.green.shade600 : Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
