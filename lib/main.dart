import 'package:flutter/material.dart';

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

      theme: ThemeData(useMaterial3: true),

      home: const Scaffold(body: Center(child: Text("Welcome to Nova AI 🚀"))),
    );
  }
}
