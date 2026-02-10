import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ScoreInputScreen()));

class ScoreInputScreen extends StatelessWidget {
  const ScoreInputScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'បញ្ចូលពិន្ទុប្រចាំខែ', // Monthly Score Entry
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('រក្សាទុក')), // Save
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ScoreCard(
                  name: 'សុខ ធានី',
                  id: '9A001',
                  gender: 'ស្រី',
                  rank: '#០១',
                  scores: {
                    'ភាសាខ្មែរ': '95',
                    'គណិតវិទ្យា': '88',
                    'រូបវិទ្យា': '92',
                    'អង់គ្លេស': '85',
                    'ជីវវិទ្យា': '89',
                    'ប្រវត្តិវិទ្យា': '90',
                  },
                  total: '549.00',
                  average: '91.50',
                ),
                ScoreCard(
                  name: 'ចាន់ បុប្ផា',
                  id: '9A002',
                  gender: 'ស្រី',
                  rank: '-',
                  scores: {}, // Empty scores
                  total: '-',
                  average: '-',
                ),
              ],
            ),
          ),
          _buildStickySaveButton(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDropdown('ថ្នាក់រៀន', 'ថ្នាក់ទី ១២ ក')),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown('ខែបញ្ចូលពិន្ទុ', 'តុលា ២០២៣')),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('គណនាស្វ័យប្រវត្តិ'), // Auto Calculate
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: [value]
                .map(
                  (String val) =>
                      DropdownMenuItem(value: val, child: Text(val)),
                )
                .toList(),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }

  Widget _buildStickySaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.save),
          label: const Text('រក្សាទុកទាំងអស់'), // Save All
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  final String name, id, gender, rank, total, average;
  final Map<String, String> scores;

  const ScoreCard({
    super.key,
    required this.name,
    required this.id,
    required this.gender,
    required this.rank,
    required this.scores,
    required this.total,
    required this.average,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: $id • $gender',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  rank,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildScoreGrid(),
            const Divider(),
            Row(
              children: [
                Text(
                  'សរុប: $total',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'មធ្យមភាគ: $average',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (total != '-')
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreGrid() {
    List<String> subjects = [
      'ភាសាខ្មែរ',
      'គណិតវិទ្យា',
      'រូបវិទ្យា',
      'អង់គ្លេស',
      'ជីវវិទ្យា',
      'ប្រវត្តិវិទ្យា',
    ];
    return Table(
      border: TableBorder.all(color: Colors.grey.shade200),
      children: [
        TableRow(
          children: subjects
              .take(3)
              .map((s) => _buildCell(s, scores[s] ?? '-'))
              .toList(),
        ),
        TableRow(
          children: subjects
              .skip(3)
              .map((s) => _buildCell(s, scores[s] ?? '-'))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCell(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
