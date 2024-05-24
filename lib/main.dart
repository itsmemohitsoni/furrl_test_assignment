import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:furrl/pages/viewframepage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

void main() {
  runApp(FrameApp());
}

class FrameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furrl Frame Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimatedFirstScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedFirstScreen extends StatefulWidget {
  const AnimatedFirstScreen({super.key});

  @override
  State<AnimatedFirstScreen> createState() => _AnimatedFirstScreenState();
}

class _AnimatedFirstScreenState extends State<AnimatedFirstScreen> {
  double _animationOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), (){
      reload();
    });

    Timer(const Duration(seconds: 4), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FramePage()));
    });
  }

  void reload(){
    setState(() {
      _animationOpacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: _animationOpacity,
            curve: Curves.easeIn,
            child: const Text('Furrl', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
      ),
    );
  }
}