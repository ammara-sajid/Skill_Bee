import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    final response = await ApiService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (response['status'] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('user_id', response['user_id'].toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Registration successful"),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Registration failed"),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightGrey = const Color(0xFFF7F7F7);
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🌟 Header Section (yellow gradient)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade700,
                      Colors.yellow.shade600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.person_add_alt_1, color: Colors.white, size: 60),
                    SizedBox(height: 10),
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                        "From learning to success — with Skill Bee",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // 🧾 Form Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildTextField(nameController, "Full Name"),
                      const SizedBox(height: 15),
                      buildTextField(emailController, "Email Address"),
                      const SizedBox(height: 15),
                      buildPasswordField(passwordController, _obscurePassword, (val) {
                        setState(() => _obscurePassword = !_obscurePassword);
                      }),
                      const SizedBox(height: 15),
                      buildPasswordField(passwordConfirmController, _obscureConfirmPassword, (val) {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      }),
                      const SizedBox(height: 25),

                      // 🟡 Register Button
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.amber)
                          : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade600,
                            elevation: 5,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🔙 Login Redirect
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, bool obscure, Function(bool) toggle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.amber.shade700,
            ),
            onPressed: () => toggle(!obscure),
          ),
        ),
      ),
    );
  }
}
