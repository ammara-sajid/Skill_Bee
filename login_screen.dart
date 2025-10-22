import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscure = true;

  void _toggle() => setState(() => _obscure = !_obscure);

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var data = await ApiService.login(email, password);
      if (data["status"] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", data["user"]["id"].toString());
        await prefs.setString("username", data["user"]["username"]);
        await prefs.setString("email", data["user"]["email"]);

        var skillData = await ApiService.getSkills(data["user"]["id"].toString());
        if (skillData["status"] == "success") {
          List<String> skills = List<String>.from(skillData["skills"]);
          await prefs.setStringList("saved_skills", skills);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Login successful"),
            backgroundColor: Colors.amber,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Invalid email or password"),
            backgroundColor: Colors.amber,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // --- App Logo ---
                CircleAvatar(
                  radius: 180,
                  backgroundColor: Colors.amber[100],
                  backgroundImage: const AssetImage('assets/images/skillbee_yellow.png'),
                ),
                //const SizedBox(height: 12),
                /*const Text(
                  "SKILL BEE",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),*/
                //const SizedBox(height: 4),
                /*const Text(
                  "A Skill Tracker App",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),*/
                const SizedBox(height: 20),

                // --- Email ---
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // subtle shadow
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFEAEAEA), // light grey background
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.email, color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.amber.shade700, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Password ---
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // subtle shadow
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )

                    ],
                      borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFEAEAEA),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.amber.shade700,
                        ),
                        onPressed: _toggle,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.amber.shade700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- Login Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- Register Link ---
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Don’t have an account? Register",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
