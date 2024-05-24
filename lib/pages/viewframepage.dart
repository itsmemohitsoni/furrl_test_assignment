import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:furrl/pages/editframepage.dart';

class FramePage extends StatefulWidget {
  @override
  _FramePageState createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  List<File> images = [];
  File? savedFrameImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: const Text("Mohit's Frame", style: TextStyle(fontSize: 24, color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 22, color: Colors.white,),
            onPressed: () {
              print("Search button pressed");
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded, size: 22, color: Colors.white,),
            onPressed: () {
              print("Save button pressed");
            },
          ),
          IconButton(onPressed: (){
            print("Bag button pressed");
          }, icon: const Icon(Icons.shopping_bag_outlined, size: 22, color: Colors.white,)),
        ],
      ),
      body: ListView(
        children: [
          // Display frame details
          Container(color: Colors.grey.shade200, height: 6,),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/mohit.jpg'),
                  radius: 32,
                ),
                title: Text("Mohit Soni", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),),
                subtitle: Text('Contact- 8769103837', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),),
              ),
            ),
          ),
          Container(color: Colors.grey.shade200, height: 6,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child:  Column(
              children: [
                const SizedBox(height: 3),
                Text(
                  '- A stylish summer look\n- Perfect for a casual day out',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey.shade700, letterSpacing: 0.1, height: 1.2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('#Organic', style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),),
                    Text('#ClassyAffair', style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),),
                    Text('#MultiColor', style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('#OverSized', style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),),
                    Text('#Minimalism', style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500),),
                    // Text('#MultiColor', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w500),),
                  ],
                )
              ],
            ),
          ),
          Container(color: Colors.grey.shade200, height: 6,),
          const Center(
            child: Text('Your Frames', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
          ),
          if(savedFrameImage != null)
            Container(
              height: MediaQuery.of(context).size.height*0.53,
              color: Colors.grey.shade500,
              child: Image.file(savedFrameImage!),
            ),
          if (savedFrameImage == null)
            Container(
              height: MediaQuery.of(context).size.height * 0.53,
              color: Colors.grey.shade300,
            ),
          Container(color: Colors.grey.shade200, height: 6,),
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 72),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditFramePage(images: images)),
                );
                if (result != null) {
                  setState(() {
                    savedFrameImage = result;
                    images = [];  // Clear the images list after saving
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.black, width: 2)
                  )
              ),
              child: const Text("Edit Frame", style: TextStyle(fontSize: 18, color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}

