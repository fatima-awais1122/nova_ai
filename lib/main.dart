import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const NovaAI());
}

class NovaAI extends StatelessWidget {
  const NovaAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova AI',
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Nova AI 🚀', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
