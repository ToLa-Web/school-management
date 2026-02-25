import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
// --- 1. DATA MODEL ---
class LeaveRequest {
  final String type;
  final String date;
  final String status;
  final String reason;
  final Color statusColor;
  LeaveRequest({
    required this.type,
    required this.date,
    required this.status,
    required this.reason,
    required this.statusColor,
  });
}
// --- 2. MAIN SCREEN ---
class StudentPermissionScreen extends StatefulWidget {
  const StudentPermissionScreen({super.key});

  @override
  State<StudentPermissionScreen> createState() =>
      _StudentPermissionScreenState();
}

class _StudentPermissionScreenState extends State<StudentPermissionScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedLeaveType = 'Sick Leave';
  DateTime? selectedDate;
  final TextEditingController _reasonController = TextEditingController();

  final List<LeaveRequest> historyData = [
    LeaveRequest(
      type: 'Sick Leave',
      date: '12 Feb 2026',
      status: 'Approved',
      reason: 'High fever and flu. Doctor prescribed 3 days of rest.',
      statusColor: const Color(0xFF50E3C2),
    ),
    LeaveRequest(
      type: 'Personal',
      date: '10 Feb 2026',
      status: 'Pending',
      reason: 'Family emergency requiring immediate travel.',
      statusColor: const Color(0xFFFFB75E),
    ),
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D3B66),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D3B66),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please choose a date first",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      historyData.insert(
        0,
        LeaveRequest(
          type: selectedLeaveType!,
          date: DateFormat('dd MMM yyyy').format(selectedDate!),
          status: 'Pending',
          reason: _reasonController.text,
          statusColor: const Color(0xFFFFB75E),
        ),
      );
      _reasonController.clear();
      selectedDate = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Permission request sent successfully!",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF50E3C2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Request Leave",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Leave Type'),
                    _buildDropdown(),
                    const SizedBox(height: 20),
                    _buildLabel('Date'),
                    _buildDatePickerDisplay(),
                    const SizedBox(height: 20),
                    _buildLabel('Reason'),
                    _buildReasonField(),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  // UI Components
  Widget _buildDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F6F8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.transparent),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLeaveType,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey.shade500,
        ),
        style: GoogleFonts.inter(
          color: const Color(0xFF0D3B66),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        items: ['Sick Leave', 'Personal Leave', 'Other'].map((val) {
          return DropdownMenuItem(value: val, child: Text(val));
        }).toList(),
        onChanged: (v) => setState(() => selectedLeaveType = v),
      ),
    ),
  );
  Widget _buildDatePickerDisplay() => Bounceable(
    onTap: _pickDate,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDate == null
                ? 'Choose Date'
                : DateFormat('dd MMM yyyy').format(selectedDate!),
            style: GoogleFonts.inter(
              color: selectedDate == null
                  ? Colors.grey.shade500
                  : const Color(0xFF0D3B66),
              fontWeight: selectedDate == null
                  ? FontWeight.w500
                  : FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.calendar_month_rounded,
            color: Colors.grey.shade500,
            size: 22,
          ),
        ],
      ),
    ),
  );
  Widget _buildReasonField() => TextFormField(
    controller: _reasonController,
    maxLines: 4,
    style: GoogleFonts.inter(
      color: const Color(0xFF0D3B66),
      fontWeight: FontWeight.w500,
    ),
    validator: (v) => (v == null || v.isEmpty) ? "Please enter a reason" : null,
    decoration: InputDecoration(
      hintText: 'Why do you need leave?',
      hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
      fillColor: const Color(0xFFF3F6F8),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );

  Widget _buildSubmitButton() => Bounceable(
    onTap: _submitForm,
    child: Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF0D3B66),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Submit Request',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Requests',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            Bounceable(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllHistoryScreen(data: historyData),
                  ),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  color: const Color(0xFF4A90E2),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (historyData.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                "No requests found.",
                style: GoogleFonts.inter(color: Colors.grey.shade500),
              ),
            ),
          )
        else
          _HistoryCard(item: historyData[0]),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10.0, left: 4),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.grey.shade600,
      ),
    ),
  );
  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      'Permissions',
      style: GoogleFonts.outfit(
        color: const Color(0xFF0D3B66),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    centerTitle: true,
    leading: Bounceable(
      onTap: () {
        Navigator.pop(context);
      },
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
  );
}

// --- 3. ALL HISTORY SCREEN ---
class AllHistoryScreen extends StatelessWidget {
  final List<LeaveRequest> data;
  const AllHistoryScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "All Leave Requests",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
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
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: data.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => _HistoryCard(item: data[index]),
      ),
    );
  }
}

// --- 4. DETAIL VIEW SCREEN ---
class RequestDetailScreen extends StatelessWidget {
  final LeaveRequest item;
  const RequestDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          "Permission Details",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
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
              Icons.close_rounded,
              color: Color(0xFF0D3B66),
              size: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
                    item.type,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: item.statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: item.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.date,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                "Reason for Leave",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.reason,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.6,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 5. REUSABLE UI CARD (Now Clickable) ---
class _HistoryCard extends StatelessWidget {
  final LeaveRequest item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestDetailScreen(item: item),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.type,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.status.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: item.statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 6),
                Text(
                  item.date,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade100,
            ),
            const SizedBox(height: 16),
            Text(
              item.reason,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
