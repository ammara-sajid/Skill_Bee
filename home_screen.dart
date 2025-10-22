import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skill_practice_tracker/services/api_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skill_practice_tracker/skill_detail_screen.dart';
import 'package:skill_practice_tracker/skill_progress_screen.dart';
import 'package:skill_practice_tracker/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class DailyProgressChart extends StatelessWidget {
  final List<int> progress;
  const DailyProgressChart({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  );
                }
                return const Text("");
              },
            ),
          ),
        ),
        barGroups: List.generate(progress.length, (index) {
          final double value = progress[index].toDouble();
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: const Color(0xFFFFC107), // yellow bars
                width: 16,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  String? userEmail;
  String? userId;
  List<int> weeklyProgress = List.filled(7, 0);
  List<Map<String, dynamic>> skills = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? "Guest";
      userEmail = prefs.getString('email') ?? "No email";
      userId = prefs.getString('user_id');
    });

    await loadProgress();
    await loadSavedSkills();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserId = prefs.getString('user_id');

    // Remove only the current user's session info
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  final List<String> quotes = [
    "🌱 Growth starts when you step out of your comfort zone.",
    "💡 Consistency beats intensity every single time.",
    "🎯 Small daily improvements lead to big results.",
    "🧠 Train your mind, just like you train your skills.",
  ];

  Future<void> loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null || email.isEmpty) return;

    List<int> newProgress = List.filled(7, 0);
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = today.subtract(Duration(days: 6 - i));
      String dateKey =
          "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

      int dailyTotal = 0;
      int countedSkills = 0;

      List<String> savedSkills =
          prefs.getStringList("saved_skills_${prefs.getString('user_id')}") ?? [];

      for (String skill in savedSkills) {
        int progress = prefs.getInt("${email}_${skill}_$dateKey") ?? 0;
        if (progress > 0) countedSkills++;
        dailyTotal += progress;
      }

      if (countedSkills > 0) dailyTotal = (dailyTotal / countedSkills).round();
      if (dailyTotal > 100) dailyTotal = 100;
      newProgress[i] = dailyTotal;
    }

    setState(() => weeklyProgress = newProgress);
  }

  Future<void> loadSavedSkills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userId == null || userId!.isEmpty) {
      setState(() => skills = []);
      return;
    }

    List<String>? savedSkills = prefs.getStringList("saved_skills_$userId") ?? [];
    setState(() {
      skills = savedSkills.map((skill) => {"skill_name": skill}).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          "Skill Bee Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFFFC107)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: const Color(0xFFFFC107),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: const AssetImage('assets/images/skillbee_yellow.png'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName ?? "Guest",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(userEmail ?? "Email",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.black87)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 120,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.85,
              ),
              items: quotes.map((quote) {
                return Card(
                  elevation: 3,
                  color: const Color(0xFFF2F2F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text("📊 Progress Log",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: DailyProgressChart(progress: weeklyProgress),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("🧩 Skill Board",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)

                ),
                IconButton( onPressed: () { Navigator.push(context,
                   MaterialPageRoute( builder: (_) => SkillDetailScreen(skillName: "All Skills"),
                  ),
                );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 18), ),

              ],
            ),
            const SizedBox(height: 10),
            skills.isEmpty
                ? const Center(child: Text("No skills added yet."))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final skill = skills[index];
                return Card(
                  elevation: 2,
                  color: const Color(0xFFF2F2F2),
                  child: ListTile(
                    title: Text(skill['skill_name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.amber),
                      onPressed: () async {
                        // Confirm before deleting
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Skill"),
                            content: Text(
                                "Are you sure you want to delete '${skill['skill_name']}'?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? userId = prefs.getString('user_id');

                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User not logged in."),
                                backgroundColor: Colors.amber,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          try {
                            final response = await ApiService.deleteSkill(userId, skill['skill_name']);

                            if (response['status'] == 'success') {
                              // ✅ Remove from UI
                              setState(() {
                                skills.removeAt(index);
                              });

                              // ✅ Remove from SharedPreferences
                              List<String> savedSkills =
                                  prefs.getStringList("saved_skills_$userId") ?? [];
                              savedSkills.remove(skill['skill_name']);
                              await prefs.setStringList("saved_skills_$userId", savedSkills);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${skill['skill_name']} deleted successfully."),
                                  backgroundColor: Colors.amber,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ?? "Error deleting skill."),
                                  backgroundColor: Colors.amber,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            print("❌ Error deleting skill: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Network or server error. Please try again later."),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }

                        }


                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SkillProgressScreen(
                            skillName: skill['skill_name']!,
                            category: "General",
                          ),
                        ),
                      );
                      await loadProgress();
                    },
                  ),
                );
              },
            )


          ],
        ),
      ),
    );
  }
}
