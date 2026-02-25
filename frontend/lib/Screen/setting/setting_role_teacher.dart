import 'package:flutter/material.dart';

class SettingsScreenTeacher extends StatelessWidget {
  const SettingsScreenTeacher({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.teal,
                      child: const Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Alexander Smith",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("Teacher of Class 12A", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            _buildSettingsGroup([
              _settingsTile(Icons.person_outline, "Account Info", Colors.blue),
              _settingsTile(
                Icons.notifications_none,
                "Notification Settings",
                Colors.orange,
              ),
              _settingsTile(
                Icons.language,
                "Language",
                Colors.indigo,
                trailing: "Khmer/English",
              ),
              _settingsTile(
                Icons.lock_outline,
                "Security & Password",
                Colors.green,
              ),
            ]),

            const SizedBox(height: 20),

            _buildSettingsGroup([
              _settingsTile(
                Icons.help_outline,
                "Help & Support",
                Colors.blueGrey,
              ),
              _settingsTile(Icons.info_outline, "About App", Colors.blueGrey),
            ]),

            const SizedBox(height: 30),

            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: .05),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}