import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'services/api_service.dart';
import 'skill_detail_screen.dart';
import 'package:skill_practice_tracker/login_screen.dart';
import 'package:intl/intl.dart';

class SkillProgressScreen extends StatefulWidget {
  final String skillName;
  final String category;

  const SkillProgressScreen({
    super.key,
    required this.skillName,
    required this.category,
  });

  @override
  State<SkillProgressScreen> createState() => _SkillProgressScreenState();
}

class _SkillProgressScreenState extends State<SkillProgressScreen> {
  String? userName;
  String? userEmail;
  String? selectedCategory;

  final Map<String, List<String>> skillModules = {
    "Learning and Personal Development": [
      "Reading habits",
      "Note-taking",
      "Time management",
      "Problem-solving",
      "Critical thinking",
    ],
    "Coding and Technology": [
      "Variables & Data Types",
      "Control Flow",
      "Data Structures",
      "Object-Oriented Programming",
      "APIs & Databases",
    ],
    "Creative and Arts": [
      "Sketching Basics",
      "Shading & Coloring",
      "Watercolor Painting",
      "Digital Art Tools",
      "Portfolio Projects",
    ],
    "Life Skills": [
      "Cooking Basics",
      "Time & Stress Management",
      "Communication Skills",
      "Leadership & Teamwork",
      "Self-Discipline",
      "Persuasion Skills",
      "Negotiation Skills",
    ],
    "Fitness and Health": [
      "Cardio Workouts",
      "Strength Training",
      "Walking and Step Tracking",
      "Nutrition and Healthy Eating",
    ],
  };

  List<bool> moduleCompletion = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
    initCategory();
  }

  Future<void> initCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    String? savedCategory = prefs.getString(
      "${email}_${widget.skillName}_selectedCategory",
    );

    String normalized = widget.category.trim();
    final matchedKey = skillModules.keys.firstWhere(
      (key) => key.toLowerCase() == normalized.toLowerCase(),
      orElse: () => normalized,
    );

    setState(() {
      selectedCategory = savedCategory ?? matchedKey;
      final modules = skillModules[selectedCategory] ?? [];
      moduleCompletion = List.generate(modules.length, (_) => false);
    });

    await loadSavedProgress();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? "Guest";
      userEmail = prefs.getString('email') ?? "No email";
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> loadSavedProgress() async {
    if (selectedCategory == null) return;

    final modules = skillModules[selectedCategory] ?? [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? savedData = prefs.getString(
      "${email}_${widget.skillName}_${selectedCategory}_$today",
    );

    List<bool> savedCompletion = List.generate(modules.length, (_) => false);

    if (savedData != null && savedData.isNotEmpty) {
      List<int> completedIndices = savedData.split(",").map(int.parse).toList();
      for (int index in completedIndices) {
        if (index < savedCompletion.length) {
          savedCompletion[index] = true;
        }
      }
    }

    setState(() {
      moduleCompletion = savedCompletion;
    });
  }

  Future<void> updateDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final today = DateTime.now();
    final dateKey =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    int completedModules = moduleCompletion.where((e) => e).length;
    int totalModules = moduleCompletion.length;
    int skillProgressPercent =
        totalModules > 0
            ? ((completedModules / totalModules) * 100).round()
            : 0;

    await prefs.setInt(
      "${email}_${widget.skillName}_$dateKey",
      skillProgressPercent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final modules = skillModules[selectedCategory] ?? [];
    int completedCount = moduleCompletion.where((done) => done).length;
    double progress = modules.isEmpty ? 0 : completedCount / modules.length;

    return Scaffold(
      backgroundColor: Colors.white, // 🟢 Background is white
      appBar: AppBar(
        backgroundColor: Colors.black, // 🖤 Black app bar
        title: Text(
          widget.skillName,
          style: const TextStyle(
            color: Colors.white, // 🤍 White text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.amber),
                // 🟡 Amber icon
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [

            Container(
              width: double.infinity,
              color: const Color(0xFFFFC107),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: const AssetImage(
                      'assets/images/skillbee_yellow.png',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? "Guest",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userEmail ?? "Email",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //const Divider(color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.home, color: Colors.amber),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.amber),
              title: const Text("Skill Board"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SkillDetailScreen(skillName: widget.skillName),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.amber),
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            selectedCategory == null
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                )
                : modules.isEmpty
                ? const Center(
                  child: Text(
                    "No modules found for this category.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Progress: ${((progress) * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.amber,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 20),

                    // Modules
                    Expanded(
                      child: ListView.builder(
                        itemCount: modules.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[100],
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CheckboxListTile(
                              title: Text(
                                modules[index],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: moduleCompletion[index],
                              activeColor: Colors.amber,
                              onChanged: (value) {
                                setState(() {
                                  moduleCompletion[index] = value ?? false;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Motivational badge
                    SizedBox(
                      width: double.infinity,
                      child: Chip(
                        label: Text(
                          progress == 1.0
                              ? "🎉 Mastered this skill!"
                              : progress >= 0.5
                              ? "⭐ Keep going, you're halfway there!"
                              : "💪 Great start! Stay consistent.",
                          style: const TextStyle(fontSize: 15),
                        ),
                        backgroundColor: Colors.amber.shade100,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Update Progress",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? email = prefs.getString('email');
                          if (email == null) return;

                          final today = DateFormat(
                            'yyyy-MM-dd',
                          ).format(DateTime.now());
                          List<int> completedIndices = [];
                          for (int i = 0; i < moduleCompletion.length; i++) {
                            if (moduleCompletion[i]) completedIndices.add(i);
                          }

                          await prefs.setString(
                            "${email}_${widget.skillName}_selectedCategory",
                            selectedCategory!,
                          );

                          await prefs.setString(
                            "${email}_${widget.skillName}_${selectedCategory}_$today",
                            completedIndices.join(","),
                          );
                          await updateDailyProgress();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Progress updated successfully!"),
                              backgroundColor: Colors.amber,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 5,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
      ),
    );
  }
}
