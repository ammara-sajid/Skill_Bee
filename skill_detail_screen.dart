import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'services/api_service.dart';
import 'skill_progress_screen.dart';
import 'package:skill_practice_tracker/login_screen.dart';

class SkillDetailScreen extends StatefulWidget {
  final String skillName;
  const SkillDetailScreen({super.key, required this.skillName});

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  String? userName;
  String? userEmail;
  bool isLoading = false;

  Map<String, String> skillCategoryMap = {
    "Creative and Arts": "Creative and Arts",
    "Learning and Personal Development": "Learning and Personal Development",
    "Coding and Technology": "Coding and Technology",
    "Life Skills": "Life Skills",
    "Fitness and Health": "Fitness and Health",
  };

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
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> saveSkill(String skillName, String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await ApiService.addSkill(userId, skillName, category);

    setState(() => isLoading = false);

    if (response['status'] == 'success') {
      final key = "saved_skills_$userId";
      List<String> savedSkills = prefs.getStringList(key) ?? [];
      if (!savedSkills.contains(skillName)) {
        savedSkills.add(skillName);
        await prefs.setStringList(key, savedSkills);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Skill saved: $skillName"),
          backgroundColor: Colors.amber.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Error saving skill"),
          backgroundColor: Colors.amber.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> skillNames = skillCategoryMap.keys.toList();
    //final lightGrey = const Color(0xFFF6F6F6);

    return Scaffold(
      //backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Skill Board",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.amber),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      // Drawer
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            //const SizedBox(height: 70),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: const Color(0xFFFFC107),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
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
            const Divider(color: Colors.grey, thickness: 0.4),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.amber),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            const Spacer(),
            const Divider(color: Colors.grey, thickness: 0.4),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.amber),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
              onTap: logout,
            ),
          ],
        ),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: skillNames.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final skillName = skillNames[index];
                  final category = skillCategoryMap[skillName]!;

                  return InkWell(
                    onTap: () async {
                      await saveSkill(skillName, category);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SkillProgressScreen(
                            skillName: skillName,
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(15),
                       // border: Border.all(color: Colors.amber.shade700, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          skillName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: isLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(Icons.arrow_forward_ios,
                            color: Colors.amber, size: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
