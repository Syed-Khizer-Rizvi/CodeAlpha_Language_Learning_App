# 🌍 Language Learning App — LinguaLearn

A comprehensive, feature-rich **Language Learning Application** built with **Flutter** as part of the **CodeAlpha App Development Internship (Task 4)**. Learn vocabulary across **13 languages** with interactive flashcards, quizzes, progress tracking, and a beautiful dark-themed UI.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 📱 About The Project

LinguaLearn is a mobile application designed to make language learning fun, engaging, and effective. Users can explore vocabulary across 13 different languages, practice with interactive flashcards, test their knowledge through quizzes, and track their learning progress over time — all stored locally on the device using SQLite.

This app was developed as **Task 4** of the **CodeAlpha App Development Internship**, demonstrating proficiency in Flutter development, state management, local database integration, and modern UI/UX design principles.

---

## ✨ Features

### 🗣️ 13 Supported Languages
- 🇪🇸 Spanish
- 🇫🇷 French
- 🇩🇪 German
- 🇮🇹 Italian
- 🇵🇹 Portuguese
- 🇮🇳 Hindi
- 🇵🇰 Urdu
- 🇸🇦 Arabic
- 🇯🇵 Japanese
- 🇰🇷 Korean
- 🇨🇳 Chinese
- 🇹🇷 Turkish
- 🇷🇺 Russian

### 📚 8 Vocabulary Categories
| Category | Examples |
|----------|----------|
| 🍕 Food & Drinks | Common food items, beverages |
| 👨‍👩‍👧‍👦 Family | Family members, relationships |
| 🔢 Numbers | Essential numbers |
| 🎨 Colors | Basic and common colors |
| 🐾 Animals | Popular animals |
| ✈️ Travel | Travel-related vocabulary |
| 📅 Days & Time | Days of the week, time expressions |
| 💬 Common Phrases | Everyday greetings and phrases |

### 🎴 Interactive Flashcards
- Flip animation to reveal translations
- Pronunciation guide for non-Latin scripts (Hindi, Arabic, Japanese, Korean, Chinese)
- Navigate through words with swipe or button controls
- Mark words as learned/favorite

### 📝 Quiz System
- Multiple-choice quizzes to test vocabulary knowledge
- Score tracking with visual bar charts (powered by `fl_chart`)
- Quiz history with date-wise performance
- Category-wise quiz filtering

### 📊 Progress Tracking
- Track learned words per language and category
- Visual progress indicators
- Bar chart visualization of quiz scores over time
- Overall learning statistics on the home screen

### 🎨 Professional UI/UX
- **Material Design 3** dark theme with gradient accents
- **Glassmorphism** card design (frosted glass effect)
- Smooth animations and transitions
- Custom navigation bar with animated icons
- Gradient shader effects on titles
- Responsive layout for all screen sizes

### 💾 Offline Storage
- All progress saved locally using **SQLite** (`sqflite` plugin)
- No internet connection required after installation
- Data persists across app restarts

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **sqflite** | Local SQLite database for progress storage |
| **fl_chart** | Bar chart visualization for quiz scores |
| **intl** | Date formatting and internationalization |
| **Material Design 3** | Modern UI components and theming |

---

## 📦 Installation & Setup

### Prerequisites
- Flutter SDK (3.x or later)
- Android Studio / VS Code
- Android SDK with NDK installed
- A physical Android device or emulator

### Steps

1. **Clone the repository**
```bash
   git clone https://github.com/Syed-Khizer-Rizvi/CodeAlpha_Language_Learning_App.git
   cd CodeAlpha_Language_Learning_App
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Run the app**
```bash
   flutter run
```

4. **Build Release APK**
```bash
   flutter build apk --release
```
   The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`

> ⚠️ **Note:** This app uses `sqflite` for local storage, which does **not** support Chrome/Web. Please test on an Android device or emulator.

---

## 📥 Download APK

You can download the latest release APK directly from the [Releases](https://github.com/Syed-Khizer-Rizvi/CodeAlpha_Language_Learning_App/releases) page.

---

## 📂 Project Structure

lib/
└── main.dart # Complete app code (~2200+ lines)
├── AppColors # Custom color palette & theme constants
├── GlassCard # Reusable glassmorphism card widget
├── DatabaseHelper # SQLite database operations (CRUD)
├── HomeScreen # Main dashboard with stats & language grid
├── CategoryScreen # Category selection with icons & colors
├── FlashcardScreen # Interactive flip-card vocabulary viewer
├── QuizScreen # Multiple-choice quiz engine
├── ProgressScreen # Learning stats & chart visualization
└── Word Data # 13 languages × 8 categories vocabulary


---

## 🎯 Key Highlights

- **2200+ lines** of well-structured Dart code in a single-file architecture
- **600+ vocabulary words** across 13 languages and 8 categories
- **Hindi language support** with Devanagari script (हिन्दी) and romanized pronunciation
- **Non-Latin script support** for Arabic, Japanese, Korean, Chinese, and Urdu
- **Zero external API dependency** — works completely offline
- **Professional dark theme** with glassmorphism effects
- **Smooth animations** including card flips, page transitions, and gradient shaders


---

## 🤝 Internship Info

| Detail | Info |
|--------|------|
| **Company** | CodeAlpha |
| **Internship** | App Development Internship |
| **Task Number** | Task 4 |
| **Task Title** | Language Learning App |
| **Intern** | Syed Khizer Rizvi |

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## ⭐ Show Your Support

If you found this project helpful or interesting, please give it a ⭐ on GitHub!

---

