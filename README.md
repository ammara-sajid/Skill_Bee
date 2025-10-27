# 🐝 Skill-Bee — Skill Tracker App

Skill-Bee is a simple and efficient **Skill Tracking Application** that helps users manage, monitor, and improve their personal skills over time.  
It allows users to **register**, **log in**, **add new skills**, **track progress**, and **view detailed skill information** — all in one app.  

---

## 🚀 Features

- 🧑‍💻 **User Authentication**
  - Register new users  
  - Login and secure access  
  - User validation (Check User)  

- 📝 **Skill Management**
  - Add new skills  
  - View all added skills  
  - Delete skills  
  - Get detailed skill information  

- 📊 **Progress Tracking**
  - Track skill progress over time  
  - View detailed progress insights  

- 📱 **Modern Frontend**
  - Developed in **Flutter (Dart)**  
  - Clean and responsive UI  
  - Interactive navigation between screens  

---

## 🏗️ Project Structure

### **Frontend (Flutter/Dart)**
**Main Screens:**
- `LoginScreen` — user login page  
- `RegisterScreen` — user registration page  
- `HomeScreen` — displays all skills  
- `SkillDetailScreen` — shows detailed info of a skill  
- `SkillProgressScreen` — shows progress and growth  

### **Backend (PHP)**
**Core Files:**
- `add_skill.php` — adds a new skill to the database  
- `get_skill.php` — retrieves skill data  
- `get_skill_progress.php` — retrieves skill progress details  
- `delete_skill.php` — deletes a skill  
- `login.php` — verifies user credentials  
- `register.php` — registers a new user  
- `get_user.php` — fetches user information  
- `checkuser.php` — checks if a user already exists  

---

## 🗄️ Database (MySQL via phpMyAdmin)

**Database Name:** `skill_tracker_db`

**Main Tables:**
- `users` — stores user account details  
- `skills` — stores skill names, user IDs, and progress  
- `skill_progress` — stores progress updates related to each skill  

## ⚙️ Setup Instructions

### 1. Backend Setup

1. Install **XAMPP** or any local PHP server.  
2. Start **Apache** and **MySQL** services.  
3. Create a new database named `skill_tracker_db` in **phpMyAdmin**.  
4. Import your database tables (if any SQL file provided).  
5. Place all PHP files in the `htdocs/skill-bee-api` folder.  

---

### 2. Frontend Setup

1. Install **Flutter SDK** and **Dart**.  
2. Clone or download this project folder.  
3. Open the project in **Android Studio** or **VS Code**.  
4. Update the base URL in your Flutter files to match your local server, e.g.  

   ```dart
   String baseUrl = "http://localhost/skill-bee-api/";
## 📸 App Preview

<img width="195" height="382" alt="Screenshot_1761126955" src="https://github.com/user-attachments/assets/b210b84c-a1b7-4921-8646-7d6a684330f2" />
<img width="195" height="382" alt="Screenshot_1761569051" src="https://github.com/user-attachments/assets/11811a55-10f3-411a-8f2e-081427679f81" />
<img width="195" height="382" alt="Screenshot_1761569595" src="https://github.com/user-attachments/assets/2a994f77-0975-4630-8374-9d3f6cc7a6f0" />
<img width="195" height="382" alt="Screenshot_1761569642" src="https://github.com/user-attachments/assets/4f5dab3e-2bb9-4bff-a98a-12417f4ce66e" />
<img width="195" height="382" alt="Screenshot_1761569649" src="https://github.com/user-attachments/assets/f2010799-2214-481b-a061-2d3dbeadcd19" />
<img width="195" height="382" alt="Screenshot_1761569658" src="https://github.com/user-attachments/assets/096f23f9-de45-4fdc-b421-475cc4106908" />
<img width="195" height="382" alt="Screenshot_1761569668" src="https://github.com/user-attachments/assets/1ca7c9b0-aa67-440b-ad6a-3d37c1984362" />


---

## 🧠 Tech Stack

| Layer | Technology |
|-------|-------------|
| Frontend | Flutter, Dart |
| Backend | PHP (Procedural) |
| Database | MySQL (via phpMyAdmin) |
| Server | Localhost (XAMPP) |

---

## 💡 Future Enhancements

- Add **skill categories** (e.g., Technical, Creative, Soft Skills)  
- Add **progress charts** and visual analytics  
- Enable **cloud database** support (e.g., Firebase or MySQL hosting)  
- Add **notifications** for daily skill updates  

---

## 👩‍💻 Author

**Ammara Sajid**  
💬 “Learning and improving one skill at a time with Skill-Bee 🐝”
