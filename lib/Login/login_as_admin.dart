import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Dashboard/admin_dashboard.dart';

void main() => runApp(const MaterialApp(home: AdminLoginPage()));

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Blue Header Background
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1BB5), // Deep Blue
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo/Icon Circle
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 50,
                        color: Color(0xFF1A1BB5),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "ចូលប្រើក្នុងនាមជាអភិបាល",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "ប្រព័ន្ធគ្រប់គ្រងសាលារៀន",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    // 3. Login Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "លេខសម្គាល់អភិបាល / អ៊ីមែល",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            Icons.badge_outlined,
                            "បញ្ចូលលេខសម្គាល់",
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            "លេខសម្ងាត់",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            Icons.lock_outline,
                            "********",
                            isPassword: true,
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "ភ្លេចលេខសម្ងាត់?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1BB5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDashboard(),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ចូលប្រើ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.login, color: Colors.amber),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 4. Tech Support Section
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFF9C4),
                            child: Icon(
                              Icons.headset_mic,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ត្រូវការជំនួយបច្ចេកទេស?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "ទំនាក់ទំនងគាំទ្រ ២៤/៧",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("ទាក់ទង"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Footer Links
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "គោលការណ៍ឯកជនភាព",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "ជំនួយ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          "អំពីកម្មវិធី",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint, {
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_outlined, color: Colors.grey)
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
