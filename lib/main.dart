import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/feed/feed_screen.dart';

void main() {
  runApp(const ProviderScope(child: WaroApp()));
}

class WaroApp extends StatelessWidget {
  const WaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARO Marketplace',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const FeedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
