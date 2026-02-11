import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActivityTile(
            Icons.science,
            "មីក្រូកុបពន្លឺនៃកោសិកា",
            "បានបញ្ចប់",
            Colors.indigo,
            "A+",
          ),
          const Divider(height: 20),
          _buildActivityTile(
            Icons.biotech,
            "ប្រវត្តិវិទ្យាភពផែនដី",
            "បានបញ្ចប់",
            Colors.teal,
            null, // No grade, shows arrow
          ),
        ],
      ),
    );
  }

  // This helper MUST be inside this class to be recognized
  Widget _buildActivityTile(
    IconData icon,
    String title,
    String status,
    Color color,
    String? grade,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          if (grade != null)
            Text(
              grade,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF007A7A),
              ),
            )
          else
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
