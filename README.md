# 🏋️‍♀️ Fitness Tracker App  
*A Flutter-based offline fitness management application*

---

## 👩‍💻 Author
**Name:** Pooja Settineni  
**Panther ID:** 002904211  
**Course:** Mobile Application Development  
**Date:** October 2025  

---

## 🎯 Project Overview
The **Fitness Tracker App** is an offline-capable Flutter mobile and web application that allows users to manage their **workouts, calorie intake, BMI progress, and routines** — all in one place.

Built using Flutter and `SharedPreferences`, it ensures **data persistence** without the need for an internet connection.  
The UI uses a **dark teal gradient theme** with responsive layouts and clean typography for a professional, motivating experience.

---

## 🎥 Demo Video
📺 **YouTube Link:** [Click here to watch the full demo](https://youtu.be/ZV694f0cjy0?si=IItfRCD51Ri0nBOz)  
*(Replace this with your actual video link after uploading your screen recording.)*

---

## ⚙️ Features

| Module | Description |
|--------|-------------|
| 🏋️ **Workout Tracker** | Add, view, and delete workouts with duration and calories burned. Data is saved locally. |
| 🍎 **Calorie Logger** | Track daily calorie intake for each meal item and maintain a daily summary. |
| 📈 **Progress (BMI)** | Calculate BMI, view categories, and visualize weekly progress trends. |
| 🧘 **Workout Routines** | Includes beginner, intermediate, and advanced routines with the ability to add custom ones. |
| 🏆 **Dashboard Summary** | Displays total workouts, calories, BMI summary, routines, goals, and motivational quotes. |
| 🔥 **Bonus Features** | Streak tracker, motivational quote generator, weekly summary insights, and Pro Fitness Tips pop-up. |

---

## 🧱 Tech Stack
- **Framework:** Flutter (Dart)
- **Storage:** SharedPreferences (local JSON persistence)
- **UI Tools:** Google Fonts, fl_chart (for graphs)
- **Platform:** Android + Web compatible
- **IDE Used:** Android Studio & VS Code

---

## 🧩 System Architecture
```plaintext
+--------------------+
|     main.dart      |
+--------------------+
          |
          ↓
+--------------------+
|     HomeScreen     |
+--------------------+
 |   |   |   |   |
 ↓   ↓   ↓   ↓   ↓
Workout Calorie Progress Routines Dashboard
