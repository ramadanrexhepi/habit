Habit Tracker (WIP)

A Flutter app designed to help users build and track daily habits with a clean UI, animated screens, and Firebase authentication.  
This project is currently **in active development**.

---

## Project Status: In Progress

This app is not yet production-ready. Core functionality is being implemented and polished step by step.  
Follow the journey or contribute if you'd like!

---

## Features Completed So Far

- **Authentication System**
  - Email & Password login/signup
  - Google Sign-In
  - Firebase Auth integration
- **Custom Login/Signup UI**
  - Animated background
  - Google button
  - Password toggle visibility
- **Today's Habits Page**
  - Floating action button to add/view habits
- **Calendar Heatmap**
  - View consistency and progress visually
- **Account Settings Screen**
  - View user info
  - Update name/email/password
  - Upload profile photo
  - Toggle light/dark theme
  - Delete account

---

## 🛠️ Work in Progress

- 📊 **Progress Screen with charts & streak tracking**
- 🔔 **Habit reminders and notifications**
- ☁️ **Cloud sync using Firestore**
- 🧠 **AI suggestions (e.g. for productivity habits)**
- 📱 **Responsive layout for tablets and web**

---

## 🔧 Tech Stack

- **Flutter** (cross-platform UI)
- **Firebase Auth** (email & Google login)
- **Google Sign-In**
- **Provider / Custom state** (for data flow)
- **Calendar heatmap plugin**
- **Animations / Framer Motion-inspired visuals**

---

## 🚀 Getting Started

> You need Flutter installed and Firebase configured.

1. **Clone the repo**
   ```bash
   git clone https://github.com/ramadanrexhepi/habit.git
   cd habit
Install packages

bash
Copy
Edit
flutter pub get
Set up Firebase

Use flutterfire configure

Ensure firebase_options.dart is generated

Enable Email/Password and Google sign-in

Run the app


Folder Structure (WIP)

Edit
lib/
├── screens/           # Home, Auth, Heatmap, Account, etc.
├── widgets/           # Reusable UI components
├── auth_gate.dart     # Controls auth redirection
├── firebase_options.dart
└── main.dart          # App entry point

Author:
Developed by @ramadanrexhepi
Currently building and expanding feature by feature.
