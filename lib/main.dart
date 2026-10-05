import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// ─── MAIN ───────────────────────────────────────────────────────────────────

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LinguaLearnApp());
}

class LinguaLearnApp extends StatelessWidget {
  const LinguaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7C4DFF),
        scaffoldBackgroundColor: const Color(0xFF0A0A1A),
        cardTheme: CardThemeData(
          color: const Color(0xFF141428),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// ─── CONSTANTS & COLORS ────────────────────────────────────────────────────

class AppColors {
  static const primary = Color(0xFF7C4DFF);
  static const primaryLight = Color(0xFFB388FF);
  static const surface = Color(0xFF141428);
  static const surfaceLight = Color(0xFF1C1C36);
  static const accent1 = Color(0xFFFF6B9D);
  static const accent2 = Color(0xFF00E5A0);
  static const accent3 = Color(0xFFFFB74D);
  static const accent4 = Color(0xFF64B5F6);
  static const bg = Color(0xFF0A0A1A);
}

// ─── LANGUAGE DATA ──────────────────────────────────────────────────────────

class LanguageInfo {
  final String code;
  final String name;
  final String flag;
  final String nativeName;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.flag,
    required this.nativeName,
  });
}

const List<LanguageInfo> availableLanguages = [
  LanguageInfo(code: 'es', name: 'Spanish', flag: '🇪🇸', nativeName: 'Español'),
  LanguageInfo(code: 'fr', name: 'French', flag: '🇫🇷', nativeName: 'Français'),
  LanguageInfo(code: 'de', name: 'German', flag: '🇩🇪', nativeName: 'Deutsch'),
  LanguageInfo(code: 'it', name: 'Italian', flag: '🇮🇹', nativeName: 'Italiano'),
  LanguageInfo(code: 'pt', name: 'Portuguese', flag: '🇧🇷', nativeName: 'Português'),
  LanguageInfo(code: 'hi', name: 'Hindi', flag: '🇮🇳', nativeName: 'हिन्दी'),
  LanguageInfo(code: 'ur', name: 'Urdu', flag: '🇵🇰', nativeName: 'اردو'),
  LanguageInfo(code: 'ar', name: 'Arabic', flag: '🇸🇦', nativeName: 'العربية'),
  LanguageInfo(code: 'ja', name: 'Japanese', flag: '🇯🇵', nativeName: '日本語'),
  LanguageInfo(code: 'ko', name: 'Korean', flag: '🇰🇷', nativeName: '한국어'),
  LanguageInfo(code: 'zh', name: 'Chinese', flag: '🇨🇳', nativeName: '中文'),
  LanguageInfo(code: 'tr', name: 'Turkish', flag: '🇹🇷', nativeName: 'Türkçe'),
  LanguageInfo(code: 'ru', name: 'Russian', flag: '🇷🇺', nativeName: 'Русский'),
];

class WordEntry {
  final String english;
  final String translation;
  final String pronunciation;
  final String category;

  const WordEntry({
    required this.english,
    required this.translation,
    required this.pronunciation,
    required this.category,
  });
}

const List<String> categories = [
  'Greetings',
  'Numbers',
  'Food & Drinks',
  'Travel',
  'Common Phrases',
  'Family',
  'Colors',
  'Days & Time',
];

const Map<String, IconData> categoryIcons = {
  'Greetings': Icons.waving_hand_rounded,
  'Numbers': Icons.tag_rounded,
  'Food & Drinks': Icons.restaurant_rounded,
  'Travel': Icons.flight_takeoff_rounded,
  'Common Phrases': Icons.chat_bubble_rounded,
  'Family': Icons.family_restroom_rounded,
  'Colors': Icons.palette_rounded,
  'Days & Time': Icons.schedule_rounded,
};

const Map<String, Color> categoryColors = {
  'Greetings': AppColors.accent3,
  'Numbers': AppColors.primary,
  'Food & Drinks': AppColors.accent1,
  'Travel': AppColors.accent4,
  'Common Phrases': AppColors.accent2,
  'Family': AppColors.accent3,
  'Colors': AppColors.primaryLight,
  'Days & Time': AppColors.accent4,
};

const Map<String, List<WordEntry>> languageWords = {
  'es': [
    WordEntry(english: 'Hello', translation: 'Hola', pronunciation: 'OH-lah', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Buenos días', pronunciation: 'BWEH-nos DEE-as', category: 'Greetings'),
    WordEntry(english: 'Good night', translation: 'Buenas noches', pronunciation: 'BWEH-nas NO-ches', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Adiós', pronunciation: 'ah-dee-OS', category: 'Greetings'),
    WordEntry(english: 'How are you?', translation: '¿Cómo estás?', pronunciation: 'KO-mo es-TAS', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Gracias', pronunciation: 'GRAH-see-as', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Por favor', pronunciation: 'por fah-VOR', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Uno', pronunciation: 'OO-no', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Dos', pronunciation: 'DOS', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Tres', pronunciation: 'TRES', category: 'Numbers'),
    WordEntry(english: 'Four', translation: 'Cuatro', pronunciation: 'KWAH-tro', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Cinco', pronunciation: 'SEEN-ko', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Diez', pronunciation: 'dee-ES', category: 'Numbers'),
    WordEntry(english: 'Hundred', translation: 'Cien', pronunciation: 'see-EN', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Agua', pronunciation: 'AH-gwah', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Pan', pronunciation: 'PAHN', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Café', pronunciation: 'kah-FEH', category: 'Food & Drinks'),
    WordEntry(english: 'Milk', translation: 'Leche', pronunciation: 'LEH-cheh', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: 'Arroz', pronunciation: 'ah-ROS', category: 'Food & Drinks'),
    WordEntry(english: 'Where is...?', translation: '¿Dónde está...?', pronunciation: 'DON-deh es-TAH', category: 'Travel'),
    WordEntry(english: 'Airport', translation: 'Aeropuerto', pronunciation: 'ah-eh-ro-PWER-to', category: 'Travel'),
    WordEntry(english: 'Hotel', translation: 'Hotel', pronunciation: 'oh-TEL', category: 'Travel'),
    WordEntry(english: 'Train', translation: 'Tren', pronunciation: 'TREN', category: 'Travel'),
    WordEntry(english: 'I love you', translation: 'Te quiero', pronunciation: 'teh kee-EH-ro', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Me llamo...', pronunciation: 'meh YAH-mo', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'No entiendo', pronunciation: 'no en-tee-EN-do', category: 'Common Phrases'),
    WordEntry(english: 'How much?', translation: '¿Cuánto cuesta?', pronunciation: 'KWAN-to KWES-tah', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Madre', pronunciation: 'MAH-dreh', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Padre', pronunciation: 'PAH-dreh', category: 'Family'),
    WordEntry(english: 'Brother', translation: 'Hermano', pronunciation: 'er-MAH-no', category: 'Family'),
    WordEntry(english: 'Sister', translation: 'Hermana', pronunciation: 'er-MAH-nah', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Rojo', pronunciation: 'RO-ho', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Azul', pronunciation: 'ah-SOOL', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'Verde', pronunciation: 'BEHR-deh', category: 'Colors'),
    WordEntry(english: 'Yellow', translation: 'Amarillo', pronunciation: 'ah-mah-REE-yo', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Lunes', pronunciation: 'LOO-nes', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Hoy', pronunciation: 'OY', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Mañana', pronunciation: 'mah-NYAH-nah', category: 'Days & Time'),
    WordEntry(english: 'Yesterday', translation: 'Ayer', pronunciation: 'ah-YER', category: 'Days & Time'),
  ],
  'fr': [
    WordEntry(english: 'Hello', translation: 'Bonjour', pronunciation: 'bohn-ZHOOR', category: 'Greetings'),
    WordEntry(english: 'Good night', translation: 'Bonne nuit', pronunciation: 'bun NWEE', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Au revoir', pronunciation: 'oh ruh-VWAHR', category: 'Greetings'),
    WordEntry(english: 'How are you?', translation: 'Comment allez-vous?', pronunciation: 'koh-MAHN tah-lay VOO', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Merci', pronunciation: 'mehr-SEE', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'S\'il vous plaît', pronunciation: 'seel voo PLEH', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Un', pronunciation: 'UHN', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Deux', pronunciation: 'DUH', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Trois', pronunciation: 'TWAH', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Cinq', pronunciation: 'SANK', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Dix', pronunciation: 'DEES', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Eau', pronunciation: 'OH', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Pain', pronunciation: 'PAN', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Café', pronunciation: 'kah-FAY', category: 'Food & Drinks'),
    WordEntry(english: 'Milk', translation: 'Lait', pronunciation: 'LEH', category: 'Food & Drinks'),
    WordEntry(english: 'Where is...?', translation: 'Où est...?', pronunciation: 'oo EH', category: 'Travel'),
    WordEntry(english: 'Airport', translation: 'Aéroport', pronunciation: 'ah-eh-ro-POR', category: 'Travel'),
    WordEntry(english: 'Hotel', translation: 'Hôtel', pronunciation: 'oh-TEL', category: 'Travel'),
    WordEntry(english: 'I love you', translation: 'Je t\'aime', pronunciation: 'zhuh TEM', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Je m\'appelle...', pronunciation: 'zhuh mah-PEL', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'Je ne comprends pas', pronunciation: 'zhuh nuh kohm-PRAHN pah', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Mère', pronunciation: 'MEHR', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Père', pronunciation: 'PEHR', category: 'Family'),
    WordEntry(english: 'Brother', translation: 'Frère', pronunciation: 'FREHR', category: 'Family'),
    WordEntry(english: 'Sister', translation: 'Sœur', pronunciation: 'SUR', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Rouge', pronunciation: 'ROOZH', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Bleu', pronunciation: 'BLUH', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'Vert', pronunciation: 'VEHR', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Lundi', pronunciation: 'luhn-DEE', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Aujourd\'hui', pronunciation: 'oh-zhoor-DWEE', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Demain', pronunciation: 'duh-MAN', category: 'Days & Time'),
  ],
  'de': [
    WordEntry(english: 'Hello', translation: 'Hallo', pronunciation: 'HAH-lo', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Guten Morgen', pronunciation: 'GOO-ten MOR-gen', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Auf Wiedersehen', pronunciation: 'owf VEE-der-zay-en', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Danke', pronunciation: 'DAHN-keh', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Bitte', pronunciation: 'BIT-teh', category: 'Greetings'),
    WordEntry(english: 'How are you?', translation: 'Wie geht es Ihnen?', pronunciation: 'vee GAYT es EE-nen', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Eins', pronunciation: 'AYNS', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Zwei', pronunciation: 'TSVAY', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Drei', pronunciation: 'DRY', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Fünf', pronunciation: 'FUENF', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Zehn', pronunciation: 'TSAYN', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Wasser', pronunciation: 'VAS-ser', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Brot', pronunciation: 'BROHT', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Kaffee', pronunciation: 'KAH-fay', category: 'Food & Drinks'),
    WordEntry(english: 'Milk', translation: 'Milch', pronunciation: 'MILKH', category: 'Food & Drinks'),
    WordEntry(english: 'Where is...?', translation: 'Wo ist...?', pronunciation: 'VOH IST', category: 'Travel'),
    WordEntry(english: 'Airport', translation: 'Flughafen', pronunciation: 'FLOOG-hah-fen', category: 'Travel'),
    WordEntry(english: 'Hotel', translation: 'Hotel', pronunciation: 'ho-TEL', category: 'Travel'),
    WordEntry(english: 'Train', translation: 'Zug', pronunciation: 'TSOOG', category: 'Travel'),
    WordEntry(english: 'I love you', translation: 'Ich liebe dich', pronunciation: 'ikh LEE-beh dikh', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Ich heiße...', pronunciation: 'ikh HY-seh', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'Ich verstehe nicht', pronunciation: 'ikh fer-SHTAY-eh nikht', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Mutter', pronunciation: 'MOO-ter', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Vater', pronunciation: 'FAH-ter', category: 'Family'),
    WordEntry(english: 'Brother', translation: 'Bruder', pronunciation: 'BROO-der', category: 'Family'),
    WordEntry(english: 'Sister', translation: 'Schwester', pronunciation: 'SHVES-ter', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Rot', pronunciation: 'ROHT', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Blau', pronunciation: 'BLOW', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'Grün', pronunciation: 'GRUEN', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Montag', pronunciation: 'MOHN-tahg', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Heute', pronunciation: 'HOY-teh', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Morgen', pronunciation: 'MOR-gen', category: 'Days & Time'),
  ],
  'it': [
    WordEntry(english: 'Hello', translation: 'Ciao', pronunciation: 'CHOW', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Buongiorno', pronunciation: 'bwon-JOR-no', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Arrivederci', pronunciation: 'ah-ree-veh-DEHR-chee', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Grazie', pronunciation: 'GRAH-tsee-eh', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Per favore', pronunciation: 'per fah-VOH-reh', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Uno', pronunciation: 'OO-no', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Due', pronunciation: 'DOO-eh', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Tre', pronunciation: 'TREH', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Cinque', pronunciation: 'CHEEN-kweh', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Dieci', pronunciation: 'dee-EH-chee', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Acqua', pronunciation: 'AH-kwah', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Pane', pronunciation: 'PAH-neh', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Caffè', pronunciation: 'kaf-FEH', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: 'Ti amo', pronunciation: 'tee AH-mo', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Mi chiamo...', pronunciation: 'mee kee-AH-mo', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Madre', pronunciation: 'MAH-dreh', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Padre', pronunciation: 'PAH-dreh', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Rosso', pronunciation: 'ROS-so', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Blu', pronunciation: 'BLOO', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'Verde', pronunciation: 'VEHR-deh', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Lunedì', pronunciation: 'loo-neh-DEE', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Oggi', pronunciation: 'OH-jee', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Domani', pronunciation: 'doh-MAH-nee', category: 'Days & Time'),
  ],
  'pt': [
    WordEntry(english: 'Hello', translation: 'Olá', pronunciation: 'oh-LAH', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Bom dia', pronunciation: 'bohm JEE-ah', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Tchau', pronunciation: 'CHOW', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Obrigado', pronunciation: 'oh-bree-GAH-doo', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Por favor', pronunciation: 'por fah-VOR', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Um', pronunciation: 'OOM', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Dois', pronunciation: 'DOYSH', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Três', pronunciation: 'TREHSH', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Cinco', pronunciation: 'SEEN-koo', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Dez', pronunciation: 'DEZH', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Água', pronunciation: 'AH-gwah', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Café', pronunciation: 'kah-FEH', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Pão', pronunciation: 'POWNG', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: 'Eu te amo', pronunciation: 'eh-oo teh AH-moo', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Meu nome é...', pronunciation: 'meh-oo NO-meh EH', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Mãe', pronunciation: 'MYNG', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Pai', pronunciation: 'PIE', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Vermelho', pronunciation: 'ver-MEH-lyoo', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Azul', pronunciation: 'ah-ZOOL', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Segunda-feira', pronunciation: 'seh-GOON-dah FAY-rah', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Hoje', pronunciation: 'OH-zhee', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Amanhã', pronunciation: 'ah-mah-NYAH', category: 'Days & Time'),
  ],
  'hi': [
    // Greetings
    WordEntry(english: 'Hello', translation: 'नमस्ते', pronunciation: 'na-MAS-tay', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'सुप्रभात', pronunciation: 'su-pra-BHAAT', category: 'Greetings'),
    WordEntry(english: 'Good night', translation: 'शुभ रात्रि', pronunciation: 'shubh RAA-tri', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'अलविदा', pronunciation: 'al-vi-DAA', category: 'Greetings'),
    WordEntry(english: 'How are you?', translation: 'आप कैसे हैं?', pronunciation: 'aap KAI-say hain', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'धन्यवाद', pronunciation: 'dhan-ya-VAAD', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'कृपया', pronunciation: 'kri-PA-yaa', category: 'Greetings'),
    WordEntry(english: 'Welcome', translation: 'स्वागत है', pronunciation: 'swa-GAT hai', category: 'Greetings'),
    // Numbers
    WordEntry(english: 'One', translation: 'एक', pronunciation: 'EK', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'दो', pronunciation: 'DO', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'तीन', pronunciation: 'TEEN', category: 'Numbers'),
    WordEntry(english: 'Four', translation: 'चार', pronunciation: 'CHAAR', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'पाँच', pronunciation: 'PAANCH', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'दस', pronunciation: 'DUS', category: 'Numbers'),
    WordEntry(english: 'Hundred', translation: 'सौ', pronunciation: 'SAU', category: 'Numbers'),
    // Food & Drinks
    WordEntry(english: 'Water', translation: 'पानी', pronunciation: 'PAA-nee', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'रोटी', pronunciation: 'RO-tee', category: 'Food & Drinks'),
    WordEntry(english: 'Tea', translation: 'चाय', pronunciation: 'CHAAY', category: 'Food & Drinks'),
    WordEntry(english: 'Milk', translation: 'दूध', pronunciation: 'DOODH', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: 'चावल', pronunciation: 'CHAA-val', category: 'Food & Drinks'),
    WordEntry(english: 'Sugar', translation: 'चीनी', pronunciation: 'CHEE-nee', category: 'Food & Drinks'),
    WordEntry(english: 'Fruit', translation: 'फल', pronunciation: 'PHAL', category: 'Food & Drinks'),
    // Travel
    WordEntry(english: 'Where is...?', translation: '...कहाँ है?', pronunciation: 'ka-HAAN hai', category: 'Travel'),
    WordEntry(english: 'Airport', translation: 'हवाई अड्डा', pronunciation: 'ha-WAA-ee AD-da', category: 'Travel'),
    WordEntry(english: 'Train', translation: 'रेलगाड़ी', pronunciation: 'rail-GAA-dee', category: 'Travel'),
    WordEntry(english: 'Bus', translation: 'बस', pronunciation: 'BUS', category: 'Travel'),
    WordEntry(english: 'Hotel', translation: 'होटल', pronunciation: 'HO-tal', category: 'Travel'),
    // Common Phrases
    WordEntry(english: 'I love you', translation: 'मैं तुमसे प्यार करता हूँ', pronunciation: 'main tum-se PYAAR kar-ta hoon', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'मेरा नाम है...', pronunciation: 'ME-ra NAAM hai', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'मुझे समझ नहीं आया', pronunciation: 'mu-JHAY sa-MAJH na-HIN AA-ya', category: 'Common Phrases'),
    WordEntry(english: 'How much?', translation: 'कितना?', pronunciation: 'kit-NAA', category: 'Common Phrases'),
    WordEntry(english: 'Yes', translation: 'हाँ', pronunciation: 'HAAN', category: 'Common Phrases'),
    WordEntry(english: 'No', translation: 'नहीं', pronunciation: 'na-HIN', category: 'Common Phrases'),
    // Family
    WordEntry(english: 'Mother', translation: 'माँ', pronunciation: 'MAAN', category: 'Family'),
    WordEntry(english: 'Father', translation: 'पिता', pronunciation: 'pi-TAA', category: 'Family'),
    WordEntry(english: 'Brother', translation: 'भाई', pronunciation: 'BHAI', category: 'Family'),
    WordEntry(english: 'Sister', translation: 'बहन', pronunciation: 'BA-hen', category: 'Family'),
    WordEntry(english: 'Son', translation: 'बेटा', pronunciation: 'BAY-ta', category: 'Family'),
    WordEntry(english: 'Daughter', translation: 'बेटी', pronunciation: 'BAY-tee', category: 'Family'),
    // Colors
    WordEntry(english: 'Red', translation: 'लाल', pronunciation: 'LAAL', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'नीला', pronunciation: 'NEE-la', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'हरा', pronunciation: 'HA-ra', category: 'Colors'),
    WordEntry(english: 'Yellow', translation: 'पीला', pronunciation: 'PEE-la', category: 'Colors'),
    WordEntry(english: 'White', translation: 'सफ़ेद', pronunciation: 'sa-FAYD', category: 'Colors'),
    WordEntry(english: 'Black', translation: 'काला', pronunciation: 'KAA-la', category: 'Colors'),
    // Days & Time
    WordEntry(english: 'Monday', translation: 'सोमवार', pronunciation: 'SOM-vaar', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'आज', pronunciation: 'AAJ', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'कल', pronunciation: 'KAL', category: 'Days & Time'),
    WordEntry(english: 'Yesterday', translation: 'कल', pronunciation: 'KAL', category: 'Days & Time'),
    WordEntry(english: 'Morning', translation: 'सुबह', pronunciation: 'SU-bah', category: 'Days & Time'),
    WordEntry(english: 'Night', translation: 'रात', pronunciation: 'RAAT', category: 'Days & Time'),
  ],
  'ur': [
    WordEntry(english: 'Hello', translation: 'السلام علیکم', pronunciation: 'as-sa-LAA-mu a-LAY-kum', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'صبح بخیر', pronunciation: 'su-bah ba-KHAYR', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'اللہ حافظ', pronunciation: 'al-LAH HAA-fiz', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'شکریہ', pronunciation: 'shu-KREE-yah', category: 'Greetings'),
    WordEntry(english: 'How are you?', translation: 'آپ کیسے ہیں؟', pronunciation: 'aap KAY-say hain', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'براہ کرم', pronunciation: 'ba-RAH-ay ka-RAM', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'ایک', pronunciation: 'AYK', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'دو', pronunciation: 'DO', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'تین', pronunciation: 'TEEN', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'پانچ', pronunciation: 'PAANCH', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'دس', pronunciation: 'DUS', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'پانی', pronunciation: 'PAA-nee', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'روٹی', pronunciation: 'RO-tee', category: 'Food & Drinks'),
    WordEntry(english: 'Tea', translation: 'چائے', pronunciation: 'CHAAY', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: 'چاول', pronunciation: 'CHAA-wal', category: 'Food & Drinks'),
    WordEntry(english: 'Where is...?', translation: '...کہاں ہے؟', pronunciation: 'ka-HAAN hai', category: 'Travel'),
    WordEntry(english: 'Airport', translation: 'ہوائی اڈا', pronunciation: 'ha-WAA-ee AD-da', category: 'Travel'),
    WordEntry(english: 'I love you', translation: 'میں تم سے پیار کرتا ہوں', pronunciation: 'main tum se PYAAR kar-ta hoon', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'میرا نام ہے...', pronunciation: 'ME-ra NAAM hai', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'مجھے سمجھ نہیں آیا', pronunciation: 'mu-JHAY sa-MAJH na-HIN AA-ya', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'امی', pronunciation: 'AM-mee', category: 'Family'),
    WordEntry(english: 'Father', translation: 'ابو', pronunciation: 'AB-boo', category: 'Family'),
    WordEntry(english: 'Brother', translation: 'بھائی', pronunciation: 'BHAI', category: 'Family'),
    WordEntry(english: 'Sister', translation: 'بہن', pronunciation: 'BA-hen', category: 'Family'),
    WordEntry(english: 'Red', translation: 'لال', pronunciation: 'LAAL', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'نیلا', pronunciation: 'NEE-la', category: 'Colors'),
    WordEntry(english: 'Green', translation: 'ہرا', pronunciation: 'HA-ra', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'پیر', pronunciation: 'PEER', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'آج', pronunciation: 'AAJ', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'کل', pronunciation: 'KAL', category: 'Days & Time'),
  ],
  'ar': [
    WordEntry(english: 'Hello', translation: 'مرحبا', pronunciation: 'MAR-ha-ba', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'صباح الخير', pronunciation: 'sa-BAAH al-KHAYR', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'مع السلامة', pronunciation: 'ma-a as-sa-LAA-ma', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'شكرا', pronunciation: 'SHUK-ran', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'من فضلك', pronunciation: 'min FAD-lak', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'واحد', pronunciation: 'WAA-hid', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'اثنان', pronunciation: 'ITH-naan', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'ثلاثة', pronunciation: 'tha-LAA-tha', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'خمسة', pronunciation: 'KHAM-sa', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'عشرة', pronunciation: 'A-sha-ra', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'ماء', pronunciation: 'MAA', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'خبز', pronunciation: 'KHUBZ', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'قهوة', pronunciation: 'QAH-wa', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: 'أحبك', pronunciation: 'u-HIB-buk', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'اسمي...', pronunciation: 'IS-mee', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'أم', pronunciation: 'UMM', category: 'Family'),
    WordEntry(english: 'Father', translation: 'أب', pronunciation: 'AB', category: 'Family'),
    WordEntry(english: 'Red', translation: 'أحمر', pronunciation: 'AH-mar', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'أزرق', pronunciation: 'AZ-raq', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'الإثنين', pronunciation: 'al-ith-NAYN', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'اليوم', pronunciation: 'al-YAWM', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'غدا', pronunciation: 'GHA-dan', category: 'Days & Time'),
  ],
  'ja': [
    WordEntry(english: 'Hello', translation: 'こんにちは', pronunciation: 'kon-NEE-chee-wah', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'おはようございます', pronunciation: 'oh-ha-YOH go-zai-MAHS', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'さようなら', pronunciation: 'sa-YOH-nah-rah', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'ありがとう', pronunciation: 'ah-ree-GAH-toh', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'お願いします', pronunciation: 'oh-neh-GAI-shee-mahs', category: 'Greetings'),
    WordEntry(english: 'One', translation: '一', pronunciation: 'EE-chee', category: 'Numbers'),
    WordEntry(english: 'Two', translation: '二', pronunciation: 'NEE', category: 'Numbers'),
    WordEntry(english: 'Three', translation: '三', pronunciation: 'SAHN', category: 'Numbers'),
    WordEntry(english: 'Five', translation: '五', pronunciation: 'GOH', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: '十', pronunciation: 'JOO', category: 'Numbers'),
    WordEntry(english: 'Water', translation: '水', pronunciation: 'MEE-zoo', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'コーヒー', pronunciation: 'KOH-hee', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: 'ご飯', pronunciation: 'GO-hahn', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: '愛してる', pronunciation: 'AI-shee-teh-roo', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: '私の名前は...', pronunciation: 'wa-TA-shee no na-MAH-eh wah', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: 'わかりません', pronunciation: 'wah-kah-ree-mah-SEN', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'お母さん', pronunciation: 'oh-KAH-sahn', category: 'Family'),
    WordEntry(english: 'Father', translation: 'お父さん', pronunciation: 'oh-TOH-sahn', category: 'Family'),
    WordEntry(english: 'Red', translation: '赤', pronunciation: 'AH-kah', category: 'Colors'),
    WordEntry(english: 'Blue', translation: '青', pronunciation: 'AH-oh', category: 'Colors'),
    WordEntry(english: 'Monday', translation: '月曜日', pronunciation: 'geh-TSOO-yoh-bee', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: '今日', pronunciation: 'KYOH', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: '明日', pronunciation: 'ah-SHEE-tah', category: 'Days & Time'),
  ],
  'ko': [
    WordEntry(english: 'Hello', translation: '안녕하세요', pronunciation: 'ahn-nyeong-ha-SAY-yo', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: '안녕히 가세요', pronunciation: 'ahn-nyeong-hee ga-SAY-yo', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: '감사합니다', pronunciation: 'gam-sa-HAM-nee-da', category: 'Greetings'),
    WordEntry(english: 'Please', translation: '주세요', pronunciation: 'joo-SAY-yo', category: 'Greetings'),
    WordEntry(english: 'One', translation: '하나', pronunciation: 'HA-na', category: 'Numbers'),
    WordEntry(english: 'Two', translation: '둘', pronunciation: 'DOOL', category: 'Numbers'),
    WordEntry(english: 'Three', translation: '셋', pronunciation: 'SET', category: 'Numbers'),
    WordEntry(english: 'Five', translation: '다섯', pronunciation: 'DA-seot', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: '열', pronunciation: 'YEOL', category: 'Numbers'),
    WordEntry(english: 'Water', translation: '물', pronunciation: 'MOOL', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: '커피', pronunciation: 'KEO-pee', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: '밥', pronunciation: 'BAP', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: '사랑해요', pronunciation: 'sa-RANG-hay-yo', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: '제 이름은...', pronunciation: 'jeh ee-REUM-eun', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: '어머니', pronunciation: 'eo-MEO-nee', category: 'Family'),
    WordEntry(english: 'Father', translation: '아버지', pronunciation: 'a-BEO-jee', category: 'Family'),
    WordEntry(english: 'Red', translation: '빨간', pronunciation: 'PPAL-gan', category: 'Colors'),
    WordEntry(english: 'Blue', translation: '파란', pronunciation: 'PA-ran', category: 'Colors'),
    WordEntry(english: 'Monday', translation: '월요일', pronunciation: 'WOL-yo-il', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: '오늘', pronunciation: 'OH-neul', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: '내일', pronunciation: 'NAE-il', category: 'Days & Time'),
  ],
  'zh': [
    WordEntry(english: 'Hello', translation: '你好', pronunciation: 'nǐ hǎo', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: '早上好', pronunciation: 'zǎo shàng hǎo', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: '再见', pronunciation: 'zài jiàn', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: '谢谢', pronunciation: 'xiè xie', category: 'Greetings'),
    WordEntry(english: 'Please', translation: '请', pronunciation: 'qǐng', category: 'Greetings'),
    WordEntry(english: 'One', translation: '一', pronunciation: 'yī', category: 'Numbers'),
    WordEntry(english: 'Two', translation: '二', pronunciation: 'èr', category: 'Numbers'),
    WordEntry(english: 'Three', translation: '三', pronunciation: 'sān', category: 'Numbers'),
    WordEntry(english: 'Five', translation: '五', pronunciation: 'wǔ', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: '十', pronunciation: 'shí', category: 'Numbers'),
    WordEntry(english: 'Water', translation: '水', pronunciation: 'shuǐ', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: '咖啡', pronunciation: 'kā fēi', category: 'Food & Drinks'),
    WordEntry(english: 'Rice', translation: '米饭', pronunciation: 'mǐ fàn', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: '我爱你', pronunciation: 'wǒ ài nǐ', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: '我叫...', pronunciation: 'wǒ jiào', category: 'Common Phrases'),
    WordEntry(english: 'I don\'t understand', translation: '我不明白', pronunciation: 'wǒ bù míng bai', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: '妈妈', pronunciation: 'mā ma', category: 'Family'),
    WordEntry(english: 'Father', translation: '爸爸', pronunciation: 'bà ba', category: 'Family'),
    WordEntry(english: 'Red', translation: '红色', pronunciation: 'hóng sè', category: 'Colors'),
    WordEntry(english: 'Blue', translation: '蓝色', pronunciation: 'lán sè', category: 'Colors'),
    WordEntry(english: 'Monday', translation: '星期一', pronunciation: 'xīng qī yī', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: '今天', pronunciation: 'jīn tiān', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: '明天', pronunciation: 'míng tiān', category: 'Days & Time'),
  ],
  'tr': [
    WordEntry(english: 'Hello', translation: 'Merhaba', pronunciation: 'mer-HA-ba', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Günaydın', pronunciation: 'guen-EYE-dun', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'Hoşça kal', pronunciation: 'HOSH-cha KAL', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Teşekkür ederim', pronunciation: 'teh-shek-KUER eh-deh-REEM', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Lütfen', pronunciation: 'LUET-fen', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Bir', pronunciation: 'BEER', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'İki', pronunciation: 'ee-KEE', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Üç', pronunciation: 'UECH', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Beş', pronunciation: 'BESH', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'On', pronunciation: 'ON', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Su', pronunciation: 'SOO', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Ekmek', pronunciation: 'ek-MEK', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Kahve', pronunciation: 'KAH-veh', category: 'Food & Drinks'),
    WordEntry(english: 'Tea', translation: 'Çay', pronunciation: 'CHAY', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: 'Seni seviyorum', pronunciation: 'SEH-nee seh-vee-YOR-um', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Benim adım...', pronunciation: 'beh-NEEM ah-DUM', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Anne', pronunciation: 'AHN-neh', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Baba', pronunciation: 'BAH-bah', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Kırmızı', pronunciation: 'kur-muh-ZUH', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Mavi', pronunciation: 'MAH-vee', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Pazartesi', pronunciation: 'pah-zar-TEH-see', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Bugün', pronunciation: 'boo-GUEN', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Yarın', pronunciation: 'YAH-run', category: 'Days & Time'),
  ],
  'ru': [
    WordEntry(english: 'Hello', translation: 'Привет', pronunciation: 'pree-VYET', category: 'Greetings'),
    WordEntry(english: 'Good morning', translation: 'Доброе утро', pronunciation: 'DOB-ro-ye OO-tro', category: 'Greetings'),
    WordEntry(english: 'Goodbye', translation: 'До свидания', pronunciation: 'da svee-DA-nee-ya', category: 'Greetings'),
    WordEntry(english: 'Thank you', translation: 'Спасибо', pronunciation: 'spa-SEE-ba', category: 'Greetings'),
    WordEntry(english: 'Please', translation: 'Пожалуйста', pronunciation: 'pa-ZHAL-sta', category: 'Greetings'),
    WordEntry(english: 'One', translation: 'Один', pronunciation: 'a-DEEN', category: 'Numbers'),
    WordEntry(english: 'Two', translation: 'Два', pronunciation: 'DVA', category: 'Numbers'),
    WordEntry(english: 'Three', translation: 'Три', pronunciation: 'TREE', category: 'Numbers'),
    WordEntry(english: 'Five', translation: 'Пять', pronunciation: 'PYAT', category: 'Numbers'),
    WordEntry(english: 'Ten', translation: 'Десять', pronunciation: 'DYEH-syat', category: 'Numbers'),
    WordEntry(english: 'Water', translation: 'Вода', pronunciation: 'va-DA', category: 'Food & Drinks'),
    WordEntry(english: 'Bread', translation: 'Хлеб', pronunciation: 'KHLYEB', category: 'Food & Drinks'),
    WordEntry(english: 'Coffee', translation: 'Кофе', pronunciation: 'KO-fye', category: 'Food & Drinks'),
    WordEntry(english: 'I love you', translation: 'Я тебя люблю', pronunciation: 'ya teh-BYA lyub-LYOO', category: 'Common Phrases'),
    WordEntry(english: 'My name is...', translation: 'Меня зовут...', pronunciation: 'meh-NYA za-VOOT', category: 'Common Phrases'),
    WordEntry(english: 'Mother', translation: 'Мама', pronunciation: 'MA-ma', category: 'Family'),
    WordEntry(english: 'Father', translation: 'Папа', pronunciation: 'PA-pa', category: 'Family'),
    WordEntry(english: 'Red', translation: 'Красный', pronunciation: 'KRAS-niy', category: 'Colors'),
    WordEntry(english: 'Blue', translation: 'Синий', pronunciation: 'SEE-niy', category: 'Colors'),
    WordEntry(english: 'Monday', translation: 'Понедельник', pronunciation: 'pa-neh-DYEL-nik', category: 'Days & Time'),
    WordEntry(english: 'Today', translation: 'Сегодня', pronunciation: 'see-VOD-nya', category: 'Days & Time'),
    WordEntry(english: 'Tomorrow', translation: 'Завтра', pronunciation: 'ZAV-tra', category: 'Days & Time'),
  ],
};

// ─── DATABASE HELPER ────────────────────────────────────────────────────────

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = p.join(dbPath, 'lingua_learn_v2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE learned_words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            language TEXT NOT NULL,
            english TEXT NOT NULL,
            category TEXT NOT NULL,
            learned_at TEXT NOT NULL,
            UNIQUE(language, english)
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            language TEXT NOT NULL,
            english TEXT NOT NULL,
            category TEXT NOT NULL,
            added_at TEXT NOT NULL,
            UNIQUE(language, english)
          )
        ''');
        await db.execute('''
          CREATE TABLE quiz_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            language TEXT NOT NULL,
            category TEXT NOT NULL,
            score INTEGER NOT NULL,
            total INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE daily_streak (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            language TEXT NOT NULL,
            words_learned INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<void> markWordLearned(String lang, String english, String category) async {
    final db = await database;
    await db.insert('learned_words', {
      'language': lang,
      'english': english,
      'category': category,
      'learned_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getLearnedWords(String lang) async {
    final db = await database;
    return await db.query('learned_words', where: 'language = ?', whereArgs: [lang]);
  }

  static Future<bool> isWordLearned(String lang, String english) async {
    final db = await database;
    final r = await db.query('learned_words', where: 'language = ? AND english = ?', whereArgs: [lang, english]);
    return r.isNotEmpty;
  }

  static Future<void> toggleFavorite(String lang, String english, String category) async {
    final db = await database;
    final existing = await db.query('favorites', where: 'language = ? AND english = ?', whereArgs: [lang, english]);
    if (existing.isNotEmpty) {
      await db.delete('favorites', where: 'language = ? AND english = ?', whereArgs: [lang, english]);
    } else {
      await db.insert('favorites', {
        'language': lang,
        'english': english,
        'category': category,
        'added_at': DateTime.now().toIso8601String(),
      });
    }
  }

  static Future<bool> isFavorite(String lang, String english) async {
    final db = await database;
    final r = await db.query('favorites', where: 'language = ? AND english = ?', whereArgs: [lang, english]);
    return r.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getFavorites(String lang) async {
    final db = await database;
    return await db.query('favorites', where: 'language = ?', whereArgs: [lang]);
  }

  static Future<void> saveQuizResult(String lang, String category, int score, int total) async {
    final db = await database;
    await db.insert('quiz_results', {
      'language': lang,
      'category': category,
      'score': score,
      'total': total,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
  }

  static Future<List<Map<String, dynamic>>> getQuizResults(String lang) async {
    final db = await database;
    return await db.query('quiz_results', where: 'language = ?', whereArgs: [lang], orderBy: 'id DESC', limit: 10);
  }

  static Future<void> logDailyActivity(String lang, int wordsLearned) async {
    final db = await database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final existing = await db.query('daily_streak', where: 'date = ?', whereArgs: [today]);
    if (existing.isNotEmpty) {
      await db.update('daily_streak', {
        'words_learned': (existing.first['words_learned'] as int) + wordsLearned,
      }, where: 'date = ?', whereArgs: [today]);
    } else {
      await db.insert('daily_streak', {
        'date': today,
        'language': lang,
        'words_learned': wordsLearned,
      });
    }
  }

  static Future<int> getStreak() async {
    final db = await database;
    final rows = await db.query('daily_streak', orderBy: 'date DESC');
    if (rows.isEmpty) return 0;
    int streak = 0;
    DateTime check = DateTime.now();
    for (final row in rows) {
      final d = DateTime.parse(row['date'] as String);
      final diff = DateTime(check.year, check.month, check.day).difference(DateTime(d.year, d.month, d.day)).inDays;
      if (diff <= 1) {
        streak++;
        check = d;
      } else {
        break;
      }
    }
    return streak;
  }

  static Future<int> getTotalWordsLearned(String lang) async {
    final db = await database;
    final r = await db.rawQuery('SELECT COUNT(*) as c FROM learned_words WHERE language = ?', [lang]);
    return r.first['c'] as int;
  }

  static Future<int> getTotalQuizzesTaken(String lang) async {
    final db = await database;
    final r = await db.rawQuery('SELECT COUNT(*) as c FROM quiz_results WHERE language = ?', [lang]);
    return r.first['c'] as int;
  }

  static Future<double> getAverageScore(String lang) async {
    final db = await database;
    final r = await db.rawQuery('SELECT AVG(CAST(score AS REAL) / total * 100) as avg FROM quiz_results WHERE language = ?', [lang]);
    final val = r.first['avg'];
    if (val == null) return 0;
    return (val as double);
  }
}

// ─── GLASSMORPHIC CARD HELPER ──────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── MAIN NAVIGATION ───────────────────────────────────────────────────────

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  String? _selectedLang;

  List<Widget> get _pages => [
    _selectedLang == null
        ? LanguageSelectPage(onSelect: (code) => setState(() => _selectedLang = code))
        : DashboardPage(langCode: _selectedLang!, onChangeLang: () => setState(() => _selectedLang = null)),
    if (_selectedLang != null) LearnPage(langCode: _selectedLang!) else const _NoLangPage(),
    if (_selectedLang != null) QuizStartPage(langCode: _selectedLang!) else const _NoLangPage(),
    if (_selectedLang != null) ProfilePage(langCode: _selectedLang!) else const _NoLangPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.primary.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Learn'),
            NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz_rounded), label: 'Quiz'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _NoLangPage extends StatelessWidget {
  const _NoLangPage();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.language_rounded, size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Select a Language', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Go to Home tab to pick a language', style: TextStyle(color: Colors.white38, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ─── LANGUAGE SELECT PAGE ───────────────────────────────────────────────────

class LanguageSelectPage extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const LanguageSelectPage({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            // Header with gradient text effect
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ).createShader(bounds),
              child: const Text('LinguaLearn', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            const Text('Choose a language to start your journey', style: TextStyle(fontSize: 15, color: Colors.white54, fontWeight: FontWeight.w400)),
            const SizedBox(height: 28),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.3,
                ),
                itemCount: availableLanguages.length,
                itemBuilder: (context, index) {
                  final lang = availableLanguages[index];
                  return GestureDetector(
                    onTap: () => onSelect(lang.code),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lang.flag, style: const TextStyle(fontSize: 38)),
                          const SizedBox(height: 10),
                          Text(lang.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
                          const SizedBox(height: 2),
                          Text(lang.nativeName, style: const TextStyle(fontSize: 12, color: Colors.white38)),
                        ],
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

// ─── DASHBOARD PAGE ─────────────────────────────────────────────────────────

class DashboardPage extends StatefulWidget {
  final String langCode;
  final VoidCallback onChangeLang;
  const DashboardPage({super.key, required this.langCode, required this.onChangeLang});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _wordsLearned = 0;
  int _quizzesTaken = 0;
  double _avgScore = 0;
  int _streak = 0;
  List<Map<String, dynamic>> _recentQuizzes = [];

  LanguageInfo get _langInfo => availableLanguages.firstWhere((l) => l.code == widget.langCode);
  int get _totalWords => languageWords[widget.langCode]?.length ?? 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final wl = await DatabaseHelper.getTotalWordsLearned(widget.langCode);
      final qt = await DatabaseHelper.getTotalQuizzesTaken(widget.langCode);
      final avg = await DatabaseHelper.getAverageScore(widget.langCode);
      final streak = await DatabaseHelper.getStreak();
      final recent = await DatabaseHelper.getQuizResults(widget.langCode);
      if (mounted) {
        setState(() {
          _wordsLearned = wl;
          _quizzesTaken = qt;
          _avgScore = avg;
          _streak = streak;
          _recentQuizzes = recent;
        });
      }
    } catch (e) {
      // silently handle
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadStats,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(_langInfo.flag, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_langInfo.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                        Text(_langInfo.nativeName, style: const TextStyle(fontSize: 13, color: Colors.white38)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onChangeLang,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swap_horiz_rounded, size: 18),
                        SizedBox(width: 4),
                        Text('Switch', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Stats cards
              Row(
                children: [
                  Expanded(child: _StatCard(icon: Icons.auto_stories_rounded, label: 'Words', value: '$_wordsLearned/$_totalWords', color: AppColors.primary, bgColor: AppColors.primary.withOpacity(0.1))),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(icon: Icons.quiz_rounded, label: 'Quizzes', value: '$_quizzesTaken', color: AppColors.accent1, bgColor: AppColors.accent1.withOpacity(0.1))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(icon: Icons.trending_up_rounded, label: 'Avg Score', value: '${_avgScore.toStringAsFixed(0)}%', color: AppColors.accent2, bgColor: AppColors.accent2.withOpacity(0.1))),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(icon: Icons.local_fire_department_rounded, label: 'Streak', value: '$_streak days', color: AppColors.accent3, bgColor: AppColors.accent3.withOpacity(0.1))),
                ],
              ),
              const SizedBox(height: 28),
              // Progress
              const Text('Learning Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$_wordsLearned of $_totalWords words', style: const TextStyle(color: Colors.white60, fontSize: 13)),
                        Text('${_totalWords > 0 ? (_wordsLearned / _totalWords * 100).toStringAsFixed(0) : 0}%',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _totalWords > 0 ? _wordsLearned / _totalWords : 0,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.06),
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Recent quiz scores chart
              if (_recentQuizzes.isNotEmpty) ...[
                const Text('Recent Quiz Scores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 14),
                GlassCard(
                  child: SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx >= 0 && idx < _recentQuizzes.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('Q${idx + 1}', style: const TextStyle(fontSize: 10, color: Colors.white38)),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.white24));
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.04), strokeWidth: 1),
                        ),
                        barGroups: List.generate(_recentQuizzes.length, (i) {
                          final q = _recentQuizzes[_recentQuizzes.length - 1 - i];
                          final pct = (q['score'] as int) / (q['total'] as int) * 100;
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: pct,
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: pct >= 80
                                      ? [AppColors.accent2.withOpacity(0.6), AppColors.accent2]
                                      : pct >= 50
                                          ? [AppColors.accent3.withOpacity(0.6), AppColors.accent3]
                                          : [AppColors.accent1.withOpacity(0.6), AppColors.accent1],
                                ),
                                width: 18,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
        ],
      ),
    );
  }
}

// ─── LEARN PAGE ─────────────────────────────────────────────────────────────

class LearnPage extends StatelessWidget {
  final String langCode;
  const LearnPage({super.key, required this.langCode});

  LanguageInfo get _langInfo => availableLanguages.firstWhere((l) => l.code == langCode);

  @override
  Widget build(BuildContext context) {
    final words = languageWords[langCode] ?? [];
    final availableCats = categories.where((c) => words.any((w) => w.category == c)).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Learn ${_langInfo.name} ${_langInfo.flag}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Pick a category to start', style: TextStyle(color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 20),
            // Favorites button
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesPage(langCode: langCode))),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent1.withOpacity(0.15), AppColors.primary.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent1.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: AppColors.accent1, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bookmarked Words', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          Text('Review your saved words', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: availableCats.length,
                itemBuilder: (context, index) {
                  final cat = availableCats[index];
                  final catWords = words.where((w) => w.category == cat).toList();
                  final catColor = categoryColors[cat] ?? AppColors.primary;
                  final catIcon = categoryIcons[cat] ?? Icons.book_rounded;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => FlashcardPage(langCode: langCode, category: cat, words: catWords),
                        ));
                      },
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: catColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(catIcon, color: catColor, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cat, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  const SizedBox(height: 2),
                                  Text('${catWords.length} words/phrases', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white24),
                          ],
                        ),
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

// ─── FLASHCARD PAGE ─────────────────────────────────────────────────────────

class FlashcardPage extends StatefulWidget {
  final String langCode;
  final String category;
  final List<WordEntry> words;
  const FlashcardPage({super.key, required this.langCode, required this.category, required this.words});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _currentIndex = 0;
  bool _showTranslation = false;
  final Map<int, bool> _favorites = {};
  final Map<int, bool> _learned = {};

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    for (int i = 0; i < widget.words.length; i++) {
      final w = widget.words[i];
      final isFav = await DatabaseHelper.isFavorite(widget.langCode, w.english);
      final isL = await DatabaseHelper.isWordLearned(widget.langCode, w.english);
      if (mounted) {
        setState(() {
          _favorites[i] = isFav;
          _learned[i] = isL;
        });
      }
    }
  }

  WordEntry get _currentWord => widget.words[_currentIndex];

  void _next() {
    if (_currentIndex < widget.words.length - 1) {
      setState(() { _currentIndex++; _showTranslation = false; });
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() { _currentIndex--; _showTranslation = false; });
    }
  }

  Future<void> _toggleFav() async {
    await DatabaseHelper.toggleFavorite(widget.langCode, _currentWord.english, _currentWord.category);
    setState(() { _favorites[_currentIndex] = !(_favorites[_currentIndex] ?? false); });
  }

  Future<void> _markLearned() async {
    await DatabaseHelper.markWordLearned(widget.langCode, _currentWord.english, _currentWord.category);
    await DatabaseHelper.logDailyActivity(widget.langCode, 1);
    if (mounted) {
      setState(() { _learned[_currentIndex] = true; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Marked as learned!'),
          backgroundColor: AppColors.accent2.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = _favorites[_currentIndex] ?? false;
    final isLearned = _learned[_currentIndex] ?? false;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? AppColors.accent1 : Colors.white38),
            onPressed: _toggleFav,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${_currentIndex + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Text(' / ${widget.words.length}', style: const TextStyle(fontSize: 15, color: Colors.white38)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.words.length,
                minHeight: 4,
                backgroundColor: Colors.white.withOpacity(0.06),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            // Flashcard
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showTranslation = !_showTranslation),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey('$_currentIndex-$_showTranslation'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: _showTranslation
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary.withOpacity(0.15), AppColors.surfaceLight],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.surface, AppColors.surfaceLight],
                            ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _showTranslation ? AppColors.primary.withOpacity(0.3) : Colors.white.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_showTranslation) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.translate_rounded, size: 36, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          Text(_currentWord.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Tap to reveal', style: TextStyle(color: Colors.white30, fontSize: 13)),
                          ),
                        ] else ...[
                          Text(_currentWord.translation, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.primaryLight), textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.volume_up_rounded, size: 18, color: AppColors.primaryLight),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_currentWord.pronunciation, style: const TextStyle(fontSize: 15, color: AppColors.primaryLight, fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(_currentWord.english, style: const TextStyle(fontSize: 15, color: Colors.white38)),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Tap to flip back', style: TextStyle(color: Colors.white30, fontSize: 13)),
                          ),
                        ],
                        if (isLearned) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent2.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accent2),
                                SizedBox(width: 6),
                                Text('Learned', style: TextStyle(color: AppColors.accent2, fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Mark as learned
            if (!isLearned)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _markLearned,
                  icon: const Icon(Icons.check_circle_rounded, size: 20),
                  label: const Text('Mark as Learned', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent2,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Nav buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex > 0 ? _prev : null,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: Colors.white70,
                      disabledBackgroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < widget.words.length - 1 ? _next : null,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAVORITES PAGE ─────────────────────────────────────────────────────────

class FavoritesPage extends StatefulWidget {
  final String langCode;
  const FavoritesPage({super.key, required this.langCode});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> _favs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final f = await DatabaseHelper.getFavorites(widget.langCode);
    if (mounted) setState(() => _favs = f);
  }

  @override
  Widget build(BuildContext context) {
    final allWords = languageWords[widget.langCode] ?? [];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Bookmarked Words')),
      body: _favs.isEmpty
          ? Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.accent1.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 48, color: AppColors.accent1),
                ),
                const SizedBox(height: 20),
                const Text('No bookmarks yet', style: TextStyle(color: Colors.white54, fontSize: 17, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                const Text('Tap the heart on flashcards to save', style: TextStyle(color: Colors.white30, fontSize: 13)),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _favs.length,
              itemBuilder: (context, index) {
                final fav = _favs[index];
                final word = allWords.where((w) => w.english == fav['english']).firstOrNull;
                if (word == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(word.english, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text('${word.translation}  ·  ${word.pronunciation}', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_rounded, color: AppColors.accent1),
                          onPressed: () async {
                            await DatabaseHelper.toggleFavorite(widget.langCode, word.english, word.category);
                            _load();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ─── QUIZ START PAGE ────────────────────────────────────────────────────────

class QuizStartPage extends StatelessWidget {
  final String langCode;
  const QuizStartPage({super.key, required this.langCode});

  LanguageInfo get _langInfo => availableLanguages.firstWhere((l) => l.code == langCode);

  @override
  Widget build(BuildContext context) {
    final words = languageWords[langCode] ?? [];
    final availableCats = categories.where((c) => words.any((w) => w.category == c)).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Quiz ${_langInfo.flag}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Test your knowledge', style: TextStyle(color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 20),
            // All categories quiz
            GestureDetector(
              onTap: () {
                if (words.length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Need at least 4 words for a quiz')));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage(langCode: langCode, category: 'All', words: words)));
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.08)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.all_inclusive_rounded, color: AppColors.primaryLight, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('All Categories', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${words.length} questions', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_arrow_rounded, color: AppColors.primaryLight, size: 28),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Or pick a category', style: TextStyle(color: Colors.white38, fontSize: 13)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableCats.length,
                itemBuilder: (context, index) {
                  final cat = availableCats[index];
                  final catWords = words.where((w) => w.category == cat).toList();
                  final catColor = categoryColors[cat] ?? AppColors.primary;
                  final catIcon = categoryIcons[cat] ?? Icons.book_rounded;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (catWords.length < 4) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Need at least 4 words for a quiz')));
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage(langCode: langCode, category: cat, words: catWords)));
                      },
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: catColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(catIcon, color: catColor, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cat, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text('${catWords.length} questions', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.play_arrow_rounded, size: 22, color: catColor.withOpacity(0.6)),
                          ],
                        ),
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

// ─── QUIZ PAGE ──────────────────────────────────────────────────────────────

class QuizPage extends StatefulWidget {
  final String langCode;
  final String category;
  final List<WordEntry> words;
  const QuizPage({super.key, required this.langCode, required this.category, required this.words});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<WordEntry> _quizWords;
  int _currentQ = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOption;
  late List<List<WordEntry>> _options;

  @override
  void initState() {
    super.initState();
    _quizWords = List.from(widget.words)..shuffle(Random());
    if (_quizWords.length > 10) _quizWords = _quizWords.sublist(0, 10);
    _generateOptions();
  }

  void _generateOptions() {
    _options = [];
    final allWords = widget.words;
    for (final q in _quizWords) {
      final others = allWords.where((w) => w.english != q.english).toList()..shuffle(Random());
      final opts = [q, ...others.take(3)]..shuffle(Random());
      _options.add(opts);
    }
  }

  void _answer(int idx) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOption = idx;
      if (_options[_currentQ][idx].english == _quizWords[_currentQ].english) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQ < _quizWords.length - 1) {
      setState(() {
        _currentQ++;
        _answered = false;
        _selectedOption = null;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    await DatabaseHelper.saveQuizResult(widget.langCode, widget.category, _score, _quizWords.length);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => QuizResultPage(score: _score, total: _quizWords.length, langCode: widget.langCode, category: widget.category),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final question = _quizWords[_currentQ];
    final opts = _options[_currentQ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Quiz: ${widget.category}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${_currentQ + 1}/${_quizWords.length}', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent2.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.accent2, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_currentQ + 1) / _quizWords.length,
                minHeight: 4,
                backgroundColor: Colors.white.withOpacity(0.06),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 28),
            // Question card
            GlassCard(
              color: AppColors.surfaceLight,
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Text('What is the translation of:', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  const SizedBox(height: 14),
                  Text(question.english, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Options
            ...List.generate(opts.length, (i) {
              final isCorrect = opts[i].english == question.english;
              Color bgColor = AppColors.surface;
              Color borderColor = Colors.white.withOpacity(0.06);
              if (_answered) {
                if (isCorrect) {
                  bgColor = AppColors.accent2.withOpacity(0.12);
                  borderColor = AppColors.accent2;
                } else if (_selectedOption == i) {
                  bgColor = AppColors.accent1.withOpacity(0.12);
                  borderColor = AppColors.accent1;
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _answer(i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: borderColor, width: 1.5),
                      ),
                      elevation: 0,
                    ),
                    child: Text(opts[i].translation, style: const TextStyle(fontSize: 15), textAlign: TextAlign.center),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(_currentQ < _quizWords.length - 1 ? 'Next Question' : 'See Results', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── QUIZ RESULT PAGE ───────────────────────────────────────────────────────

class QuizResultPage extends StatelessWidget {
  final int score;
  final int total;
  final String langCode;
  final String category;
  const QuizResultPage({super.key, required this.score, required this.total, required this.langCode, required this.category});

  @override
  Widget build(BuildContext context) {
    final pct = (score / total * 100).round();
    final emoji = pct >= 80 ? '🎉' : pct >= 50 ? '👍' : '💪';
    final msg = pct >= 80 ? 'Excellent!' : pct >= 50 ? 'Good job!' : 'Keep practicing!';
    final color = pct >= 80 ? AppColors.accent2 : pct >= 50 ? AppColors.accent3 : AppColors.accent1;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Quiz Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(msg, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: color)),
              const SizedBox(height: 28),
              GlassCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Text('$pct%', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: color)),
                    const SizedBox(height: 8),
                    Text('$score out of $total correct', style: const TextStyle(fontSize: 15, color: Colors.white60)),
                    const SizedBox(height: 4),
                    Text('Category: $category', style: const TextStyle(color: Colors.white30, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Quizzes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PROFILE PAGE ───────────────────────────────────────────────────────────

class ProfilePage extends StatefulWidget {
  final String langCode;
  const ProfilePage({super.key, required this.langCode});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _wordsLearned = 0;
  int _quizzesTaken = 0;
  double _avgScore = 0;
  int _streak = 0;
  int _totalFavs = 0;
  List<Map<String, dynamic>> _quizHistory = [];

  LanguageInfo get _langInfo => availableLanguages.firstWhere((l) => l.code == widget.langCode);
  int get _totalWords => languageWords[widget.langCode]?.length ?? 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final wl = await DatabaseHelper.getTotalWordsLearned(widget.langCode);
      final qt = await DatabaseHelper.getTotalQuizzesTaken(widget.langCode);
      final avg = await DatabaseHelper.getAverageScore(widget.langCode);
      final streak = await DatabaseHelper.getStreak();
      final favs = await DatabaseHelper.getFavorites(widget.langCode);
      final history = await DatabaseHelper.getQuizResults(widget.langCode);
      if (mounted) {
        setState(() {
          _wordsLearned = wl;
          _quizzesTaken = qt;
          _avgScore = avg;
          _streak = streak;
          _totalFavs = favs.length;
          _quizHistory = history;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('Your Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Learning ${_langInfo.name} ${_langInfo.flag}', style: const TextStyle(color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 24),
            // Streak banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent3.withOpacity(0.18), AppColors.accent3.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent3.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_streak Day Streak', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accent3)),
                      const Text('Keep it going!', style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Stats row
            Row(
              children: [
                Expanded(child: _MiniStat(value: '$_wordsLearned', label: 'Words')),
                const SizedBox(width: 8),
                Expanded(child: _MiniStat(value: '$_quizzesTaken', label: 'Quizzes')),
                const SizedBox(width: 8),
                Expanded(child: _MiniStat(value: '${_avgScore.toStringAsFixed(0)}%', label: 'Avg Score')),
                const SizedBox(width: 8),
                Expanded(child: _MiniStat(value: '$_totalFavs', label: 'Saved')),
              ],
            ),
            const SizedBox(height: 28),
            // Category progress
            const Text('Category Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            ...categories.where((c) {
              final words = languageWords[widget.langCode] ?? [];
              return words.any((w) => w.category == c);
            }).map((cat) {
              final words = languageWords[widget.langCode]!.where((w) => w.category == cat).toList();
              final catColor = categoryColors[cat] ?? AppColors.primary;
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.getLearnedWords(widget.langCode),
                builder: (context, snap) {
                  final learned = snap.data?.where((w) => w['category'] == cat).length ?? 0;
                  final total = words.length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cat, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text('$learned/$total', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: total > 0 ? learned / total : 0,
                              minHeight: 6,
                              backgroundColor: Colors.white.withOpacity(0.06),
                              valueColor: AlwaysStoppedAnimation(catColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 20),
            // Quiz history
            if (_quizHistory.isNotEmpty) ...[
              const Text('Quiz History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              ..._quizHistory.map((q) {
                final pct = ((q['score'] as int) / (q['total'] as int) * 100).round();
                final color = pct >= 80 ? AppColors.accent2 : pct >= 50 ? AppColors.accent3 : AppColors.accent1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text('$pct%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(q['category'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('${q['score']}/${q['total']} correct  ·  ${q['date']}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}