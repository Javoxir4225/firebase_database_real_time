
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modil6_task7/all_posts.dart';

void main(List<String> args)async {

  // ensureInitializing
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing default firebase app
 await Firebase.initializeApp();
  runApp(const MyHome());
}
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.acmeTextTheme(),),
      home: const MyAllPost(),
    );
  }
}