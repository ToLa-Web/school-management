import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: SettingsScreenTeacher()));

class SettingsScreenTeacher extends StatelessWidget {
  const SettingsScreenTeacher({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'ការកំណត់',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ), // Replace with actual image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "លោក Alexander Smith",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "គ្រូបង្រៀនថ្នាក់ទី ១២A",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 30),

            // Settings Group 1
            _buildSettingsGroup([
              _settingsTile(Icons.person_outline, "ព័ត៌មានគណនី", Colors.blue),
              _settingsTile(
                Icons.notifications_none,
                "ការកំណត់ការជូនដំណឹង",
                Colors.orange,
              ),
              _settingsTile(
                Icons.language,
                "ភាសា",
                Colors.indigo,
                trailing: "ខ្មែរ/English",
              ),
              _settingsTile(
                Icons.lock_outline,
                "សុវត្ថិភាព និងលេខសម្ងាត់",
                Colors.green,
              ),
            ]),

            SizedBox(height: 20),

            // Settings Group 2
            _buildSettingsGroup([
              _settingsTile(
                Icons.help_outline,
                "ជំនួយ និងការគាំទ្រ",
                Colors.blueGrey,
              ),
              _settingsTile(
                Icons.info_outline,
                "អំពីកម្មវិធី",
                Colors.blueGrey,
              ),
            ]),

            SizedBox(height: 30),

            // Logout Button
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text(
                "ចាកចេញ",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: .05),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(children: tiles),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String title,
    Color iconColor, {
    String? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: TextStyle(color: Colors.grey)),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
