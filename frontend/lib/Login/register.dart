import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/services/oauth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _apiService = ApiService();
  final _oauthService = OAuthService();

  // Controllers per tab (Teacher=0, Student=1, Parent=2)
  final List<TextEditingController> _fullNameControllers =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _emailControllers =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _passwordControllers =
      List.generate(3, (_) => TextEditingController());

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  String? _errorMessage;
  bool _isObscured = true;

  bool get _anyLoading => _isLoading || _isGoogleLoading || _isFacebookLoading;

  static const List<String> _tabLabels = ['Teacher', 'Student', 'Parent'];
  static const List<String> _dashboardRoutes = [
    '/TeacherDashboard',
    '/StudentDashboard',
    '/ParentDashboard',
  ];
  static const List<String> _loginRoutes = [
    '/login-teacher',
    '/login-student',
    '/ParentLoginScreen',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() => setState(() => _errorMessage = null));
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var list in [
      _fullNameControllers,
      _emailControllers,
      _passwordControllers,
    ]) {
      for (var c in list) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final tabIndex = _tabController.index;
    final fullName = _fullNameControllers[tabIndex].text.trim();
    final email = _emailControllers[tabIndex].text.trim();
    final password = _passwordControllers[tabIndex].text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all required fields');
      return;
    }
    if (password.length < 6) {
      setState(
          () => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.register(
        UserCreateDto(email: email, password: password, username: fullName),
      );
      if (!mounted) return;
      if (result != null) {
        _showVerificationDialog(email);
      } else {
        setState(() => _errorMessage = 'Registration failed');
      }
    } catch (e) {
      if (!mounted) return;
      setState(
          () => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _oauthService.signInWithGoogle();
      if (!mounted) return;
      if (response != null) {
        Navigator.pushReplacementNamed(
            context, _dashboardRoutes[_tabController.index]);
      }
    } catch (e) {
      if (!mounted) return;
      setState(
          () => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleFacebookSignUp() async {
    setState(() {
      _isFacebookLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _oauthService.signInWithFacebook();
      if (!mounted) return;
      if (response != null) {
        Navigator.pushReplacementNamed(
            context, _dashboardRoutes[_tabController.index]);
      }
    } catch (e) {
      if (!mounted) return;
      setState(
          () => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isFacebookLoading = false);
    }
  }

  void _showVerificationDialog(String email) {
    final codeController = TextEditingController();
    bool isVerifying = false;
    String? verifyError;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Column(
                children: [
                  Icon(Icons.mark_email_read_outlined,
                      size: 56, color: Color(0xFF007A8C)),
                  SizedBox(height: 12),
                  Text('Email Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'We sent a verification code to\n$email',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      letterSpacing: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '------',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade300, letterSpacing: 10),
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFF007A8C), width: 2),
                      ),
                    ),
                  ),
                  if (verifyError != null) ...[
                    const SizedBox(height: 10),
                    Text(verifyError!,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      try {
                        await _apiService
                            .requestEmailVerificationCode(email);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('A new code has been sent')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setDialogState(
                              () => verifyError = 'Failed to resend code');
                        }
                      }
                    },
                    child: const Text('Resend Code',
                        style: TextStyle(color: Color(0xFF007A8C))),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.pushReplacementNamed(
                        context, _loginRoutes[_tabController.index]);
                  },
                  child: const Text('Skip',
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A8C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    onPressed: isVerifying
                        ? null
                        : () async {
                            final code = codeController.text.trim();
                            if (code.length != 6) {
                              setDialogState(() => verifyError =
                                  'Please enter the 6-digit code');
                              return;
                            }
                            setDialogState(() {
                              isVerifying = true;
                              verifyError = null;
                            });
                            try {
                              final success = await _apiService.verifyEmail(
                                  email, code);
                              if (!ctx.mounted) return;
                              if (success) {
                                Navigator.of(ctx).pop();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Verified successfully! Please log in'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(context,
                                      _loginRoutes[_tabController.index]);
                                }
                              } else {
                                setDialogState(() => verifyError =
                                    'Invalid verification code');
                              }
                            } catch (e) {
                              if (ctx.mounted) {
                                setDialogState(() => verifyError = e
                                    .toString()
                                    .replaceFirst('Exception: ', ''));
                              }
                            } finally {
                              if (ctx.mounted) {
                                setDialogState(() => isVerifying = false);
                              }
                            }
                          },
                    child: isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Verify',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF007A8C);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Gradient header ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF007A8C), Color(0xFF00ACC1)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Back + title
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "EduPortal",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.person_add_alt_1,
                        color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Fill in your information to get started",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    // Tab bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black54,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                        tabs: _tabLabels
                            .map((t) => Tab(text: t))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Error banner
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: const Color(0xFFFFCDD2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_errorMessage!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),

                    // Form fields
                    AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, _) {
                        final idx = _tabController.index;
                        return Column(
                          children: [
                            _buildField("Full Name", Icons.person_outline,
                                "Enter your full name",
                                _fullNameControllers[idx]),
                            const SizedBox(height: 14),
                            _buildField("Email", Icons.email_outlined,
                                "example@gmail.com",
                                _emailControllers[idx],
                                keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 14),
                            _buildPasswordField(idx),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: primary.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _anyLoading ? null : _handleRegister,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text("Create Account",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: Color(0xFFD0D5DD))),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("or sign up with",
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13)),
                        ),
                        const Expanded(
                            child: Divider(color: Color(0xFFD0D5DD))),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // OAuth buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildOAuthButton(
                            onPressed:
                                _anyLoading ? null : _handleGoogleSignUp,
                            icon: FaIcon(FontAwesomeIcons.google, size: 20, color: Color(0xFFDB4437)),
                            label: "Google",
                            isLoading: _isGoogleLoading,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildOAuthButton(
                            onPressed: _anyLoading
                                ? null
                                : _handleFacebookSignUp,
                            icon: FaIcon(FontAwesomeIcons.facebookF, size: 20, color: Color(0xFF1877F2)),
                            label: "Facebook",
                            isLoading: _isFacebookLoading,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context,
                              _loginRoutes[_tabController.index]),
                          child: const Text("Log in",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
                fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, color: const Color(0xFF98A2B3), size: 20),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF007A8C), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(int tabIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
                fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordControllers[tabIndex],
          obscureText: _isObscured,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline,
                color: Color(0xFF98A2B3), size: 20),
            hintText: "Min. 6 characters",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF98A2B3),
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _isObscured = !_isObscured),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFF007A8C), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOAuthButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required bool isLoading,
  }) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE4E7EC)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(label,
                      style: const TextStyle(
                          color: Color(0xFF344054),
                          fontWeight: FontWeight.w500)),
                ],
              ),
      ),
    );
  }
}
