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

**Connection Example:**
```php
<?php
$conn = new mysqli("localhost", "root", "", "skill_tracker_db");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
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

*(Add screenshots or GIFs of your app here — e.g., login screen, home screen, etc.)*

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
