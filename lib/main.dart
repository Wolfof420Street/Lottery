import 'package:flutter/material.dart';
import 'screens/lottery_picker_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery Number Picker',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LotteryPickerScreen(),
    );
  }
}
