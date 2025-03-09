import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommunityPostScreen(),
    );
  }
}

class CommunityPostScreen extends StatefulWidget {
  @override
  _CommunityPostScreenState createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  File? _selectedVideo;
  File? _selectedImage;
  String? _textPost;
  bool _isTextPost = false;
  VideoPlayerController? _videoController;

  void _clearSelections() {
    setState(() {
      _selectedVideo = null;
      _selectedImage = null;
      _textPost = null;
      _isTextPost = false;
      _videoController?.dispose();
      _videoController = null;
    });
  }

  Future<void> _pickVideo() async {
    _clearSelections();
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 20 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Video size must be within 20MB'),
        ));
        return;
      }

      setState(() {
        _selectedVideo = file;
        _videoController = VideoPlayerController.file(_selectedVideo!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      });
    }
  }

  Future<void> _pickImage() async {
    _clearSelections();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 5 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image size must be within 5MB'),
        ));
        return;
      }

      setState(() {
        _selectedImage = file;
      });
    }
  }

  void _enableTextPost() {
    _clearSelections();
    setState(() {
      _textPost = '';
      _isTextPost = true;
    });
  }

  void _toggleVideoPlayback() {
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back, size: 28),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Community Post',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Post Content',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_1280.png'),
                        ),
                        SizedBox(width: 8),
                        Text('Makise Kurisu',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.verified, color: Colors.blue, size: 18)
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                      maxLength: 300,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText:
                            "EVERYONE STAY CALM!!! You won't believe this. I had an AI chat with Coach S yest...",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Post Type', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('Video'),
                    selected: _selectedVideo != null,
                    onSelected: (_) => _pickVideo(),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Gallery'),
                    selected: _selectedImage != null,
                    onSelected: (_) => _pickImage(),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text('Text'),
                    selected: _isTextPost,
                    onSelected: (_) => _enableTextPost(),
                  ),
                ],
              ),
              if (_selectedVideo != null &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
                Container(
                  width: double.infinity,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                      IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                        onPressed: _toggleVideoPlayback,
                      ),
                    ],
                  ),
                ),
              if (_selectedImage != null)
                Container(
                  width: double.infinity,
                  height: 250,
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              if (_isTextPost)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: TextField(
                    onChanged: (value) => setState(() => _textPost = value),
                    maxLength: 500,
                    decoration: InputDecoration(
                        hintText: 'Write your text post here...'),
                  ),
                ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child:
                        Text('Continue', style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
