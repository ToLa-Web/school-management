import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

/// Lists all students with search, edit (dialog) and delete capabilities.
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  static const _teal = Color(0xFF00B2B2);
  static const _deepBlue = Color(0xFF0D3B66);
  static const _bg = Color(0xFFF3F6F8);

  final _api = ApiService();
  List<StudentDto> _students = [];
  bool _isLoading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await _api.getStudents();
      if (mounted) setState(() { _students = list; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<StudentDto> get _filtered {
    if (_search.isEmpty) return _students;
    final q = _search.toLowerCase();
    return _students.where((s) =>
        s.fullName.toLowerCase().contains(q) ||
        (s.gender ?? '').toLowerCase().contains(q)).toList();
  }

  // ─── Delete ───
  Future<void> _confirmDelete(StudentDto s) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Student', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: _deepBlue)),
        content: Text('Delete ${s.fullName}? This cannot be undone.',
            style: GoogleFonts.inter(color: Colors.grey.shade700)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      await _api.deleteStudent(s.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${s.fullName} deleted', style: GoogleFonts.inter()),
          backgroundColor: _teal,
          behavior: SnackBarBehavior.floating,
        ));
        _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed: $e', style: GoogleFonts.inter()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  // ─── Edit ───
  Future<void> _showEditDialog(StudentDto s) async {
    final firstCtrl = TextEditingController(text: s.firstName);
    final lastCtrl = TextEditingController(text: s.lastName);
    final phoneCtrl = TextEditingController(text: s.phone ?? '');
    final addressCtrl = TextEditingController(text: s.address ?? '');
    String? gender = s.gender;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Edit Student',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: _deepBlue)),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _field('First Name', firstCtrl),
              const SizedBox(height: 10),
              _field('Last Name', lastCtrl),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: _bg, borderRadius: BorderRadius.circular(14)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: gender,
                    hint: Text('Gender',
                        style: GoogleFonts.inter(color: Colors.grey.shade400)),
                    items: ['Male', 'Female', 'Other']
                        .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g,
                                style: GoogleFonts.inter(color: _deepBlue))))
                        .toList(),
                    onChanged: (v) => setDlg(() => gender = v),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _field('Phone', phoneCtrl),
              const SizedBox(height: 10),
              _field('Address', addressCtrl),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                final updated = StudentDto(
                  id: s.id,
                  firstName: firstCtrl.text.trim(),
                  lastName: lastCtrl.text.trim(),
                  gender: gender,
                  dateOfBirth: s.dateOfBirth,
                  phone: phoneCtrl.text.trim().isEmpty
                      ? null
                      : phoneCtrl.text.trim(),
                  address: addressCtrl.text.trim().isEmpty
                      ? null
                      : addressCtrl.text.trim(),
                  isActive: s.isActive,
                  createdAt: s.createdAt,
                );
                try {
                  await _api.updateStudent(s.id, updated);
                  if (ctx.mounted) Navigator.pop(ctx, true);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.redAccent));
                  }
                }
              },
              child: Text('Save',
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
    if (saved == true) _load();
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
                Text('All Students',
                    style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _deepBlue)),
                const SizedBox(height: 6),
                Text('${_students.length} students total',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: Colors.grey.shade500)),
                const SizedBox(height: 20),

                // Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: GoogleFonts.inter(fontSize: 15, color: _deepBlue),
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      hintStyle:
                          GoogleFonts.inter(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      icon: Icon(Icons.search_rounded,
                          color: Colors.grey.shade400),
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
                              child: Text('No students found',
                                  style: GoogleFonts.inter(
                                      color: Colors.grey)))
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(
                                        parent:
                                            BouncingScrollPhysics()),
                                itemCount: _filtered.length,
                                itemBuilder: (_, i) =>
                                    _studentCard(_filtered[i]),
                              ),
                            ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _studentCard(StudentDto s) {
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
              offset: const Offset(0, 5))
        ],
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: _teal.withValues(alpha: 0.1),
          child: Text(
            s.firstName.isNotEmpty ? s.firstName[0].toUpperCase() : '?',
            style: GoogleFonts.outfit(
                color: _teal, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.fullName,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _deepBlue)),
                const SizedBox(height: 2),
                Text(
                    [s.gender, s.phone]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' • '),
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.grey.shade500)),
              ]),
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: _teal, size: 20),
          tooltip: 'Edit',
          onPressed: () => _showEditDialog(s),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded,
              color: Colors.redAccent, size: 20),
          tooltip: 'Delete',
          onPressed: () => _confirmDelete(s),
        ),
      ]),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: GoogleFonts.inter(
          fontSize: 15, color: _deepBlue, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13),
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
