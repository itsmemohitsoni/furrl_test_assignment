import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class EditFramePage extends StatefulWidget {
  final List<File> images;

  EditFramePage({required this.images});

  @override
  _EditFramePageState createState() => _EditFramePageState();
}

class _EditFramePageState extends State<EditFramePage> {
  final ImagePicker _picker = ImagePicker();
  List<FrameImage> frameImages = [];
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    frameImages = widget.images.map((file) => FrameImage(imageFile: file)).toList();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        frameImages.add(FrameImage(imageFile: File(pickedFile.path)));
      });
    }
  }

  Future<void> _saveFrame() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final imgFile = File('${directory.path}/saved_frame_${DateTime.now().millisecondsSinceEpoch}.png');
      await imgFile.writeAsBytes(pngBytes);

      Navigator.pop(context, imgFile);
    } catch (e) {
      print('Error saving frame: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.deepPurple.shade400,
        title: const Text(
          "Edit Frame",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 22, color: Colors.white),
            onPressed: () {
              print("Search button pressed");
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded, size: 22, color: Colors.white),
            onPressed: (){
              print("Bookmark button pressed");
            },
          ),
          IconButton(
            onPressed: () {
              print("Bag button pressed");
            },
            icon: const Icon(Icons.shopping_bag_outlined, size: 22, color: Colors.white),
          ),

        ],
      ),
      body: Column(
        children: [
          Container(color: Colors.grey.shade200, height: 6,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey.shade300,
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(children: frameImages,),
                    ),),
                ],
                  ),),),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton(
              onPressed: _saveFrame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 2)),
              ),
              child: const Text(
                'Save Frame',
                style: TextStyle(fontSize: 21, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8,),
          Center(
            child: OutlinedButton(
              onPressed: (){
                Navigator.pop(context, true);
              },
              style: OutlinedButton.styleFrom(
                elevation: 5,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 5),
                )
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 21, color: Colors.deepPurple),
            ),
          ),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 32, color: Colors.white,),
        tooltip: 'Add image',
      ),
    );
  }
}

class FrameImage extends StatefulWidget {
  final File imageFile;

  FrameImage({required this.imageFile});

  @override
  _FrameImageState createState() => _FrameImageState();
}

class _FrameImageState extends State<FrameImage> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        _previousOffset = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
          _offset += details.focalPoint - _previousOffset;
          _previousOffset = details.focalPoint;
        });
      },
      child: Transform(
        transform: Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(_scale),
        child: Positioned(
          left: 10,
          top: 10,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
