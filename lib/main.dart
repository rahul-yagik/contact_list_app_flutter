import 'package:contacts/screens/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 1, 82));

final theme = ThemeData().copyWith(
    textTheme: GoogleFonts.radioCanadaTextTheme(), colorScheme: colorScheme);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Contacts',
      theme: theme,
      home: const ContactsScreen(),
    );
  }
}
