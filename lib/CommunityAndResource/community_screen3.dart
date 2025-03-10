import 'package:chewie/chewie.dart';
import 'package:fitcoach/Firebase_functions/firebasefunctions.dart';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';
import 'package:fitcoach/utility/resultDialoge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class CommunityPostScreen extends StatefulWidget {
  @override
  _CommunityPostScreenState createState() => _CommunityPostScreenState();
}

class _CommunityPostScreenState extends State<CommunityPostScreen> {
  File? _selectedVideo;
  File? _selectedImage;
  TextEditingController captionController = TextEditingController();
  String? _textPost;
  bool _isTextPost = false;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  void _clearSelections() {
    setState(() {
      _selectedVideo = null;
      _selectedImage = null;
      _textPost = null;
      _isTextPost = false;
      _videoController?.dispose();
      _chewieController?.dispose();
      _videoController = null;
      _chewieController = null;
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
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: true,
              looping: true,
            );
            setState(() {});
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
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: const Color.fromARGB(221, 227, 226, 226)),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 25,
                        color: AppColors.gray80,
                      ),
                    ),
                    // Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        'Community Post',
                        style: TextStyle(
                            color: AppColors.blue60,
                            fontWeight: FontWeight.bold),
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
                      color: AppColors.gray10,
                      borderRadius: BorderRadius.circular(37)),
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
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "caption can't be empty";
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 5,
                        maxLength: 300,
                        controller: captionController,
                        decoration: InputDecoration(
                          fillColor: AppColors.backgroundLight,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray80,
                              width: 1.5, // Thinner border for a softer look
                            ),
                            borderRadius: BorderRadius.circular(
                                20), // Slightly more rounded corners
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray80,
                              width: 2, // Slightly thicker when focused
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          hintText: "Write your Caption here...",
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Post Type',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: _pickVideo,
                      child: _buildPostTypeButton(
                          "assets/community_and_resource/playicon.png",
                          'Video',
                          _selectedVideo != null),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _buildPostTypeButton(
                          "assets/community_and_resource/galleryicon.png",
                          'Gallery',
                          _selectedImage != null),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: _enableTextPost,
                      child: _buildPostTypeButton(
                          "assets/community_and_resource/texticon.png",
                          'Text',
                          _isTextPost),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (_selectedVideo != null &&
                    _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized)
                  SizedBox(
                    height: 300,
                    child: Chewie(controller: _chewieController!),
                  ),
                if (_selectedImage != null)
                  Container(
                    width: double.infinity,
                    height: 250,
                    child: Image.file(_selectedImage!, fit: BoxFit.contain),
                  ),
                if (_isTextPost)
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      child: TextField(
                        onChanged: (value) => setState(() => _textPost = value),
                        maxLines: 8,
                        maxLength: 500,
                        decoration: InputDecoration(
                          fillColor: AppColors.backgroundLight,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray80,
                              width: 1.5, // Thinner border for a softer look
                            ),
                            borderRadius: BorderRadius.circular(
                                20), // Slightly more rounded corners
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gray80,
                              width: 2, // Slightly thicker when focused
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          hintText: "Write your Post here...",
                        ),
                      )),
                if (_selectedImage == null &&
                    !_isTextPost &&
                    _selectedVideo == null)
                  SizedBox(
                    height: 250,
                  ),

                // Spacer(),
                SizedBox(
                  height: 10,
                ),
                buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContinueButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backgroundDark,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      onPressed: () {
        if (captionController.text != "") {
          submitPostinfo(captionController.text, "111", "tester dass");
        }
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Continue",
              style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: AppColors.textLight),
        ],
      ),
    );
  }

  submitPostinfo(String caption, String userid, String username) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    File? attachedFile;
    String postType;

    if (_selectedVideo != null) {
      postType = "video";

      attachedFile = _selectedVideo!;
    } else if (_selectedImage != null) {
      postType = 'image';
      attachedFile = _selectedImage!;
    } else if (_isTextPost && _textPost != null && _textPost!.isNotEmpty) {
      postType = 'text';
    } else {
      postType = 'text';
    }

    createPost(userid, postType, caption, _textPost ?? "", username)
        .then((value) {
      if (value!.isNotEmpty || value != "") {
        Navigator.pop(context);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => resultDialog(
              buttonText: "See My Post",
              context: context,
              icon: Icons.check,
              iconBackgroundColor: AppColors.green10,
              message:
                  "You have Successfull posted a post.\n Let's see now. Shall we?🙌🏻",
              title: "Post Successfull",
              onButtonPressed: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.commmunityScreen2);
              }),
        );
      }
      // else {
      //   Navigator.pop(context);
      // }
    });
  }
}

Widget _buildPostTypeButton(String iconpath, String label, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryorange : Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: Colors.grey[400]!, width: isSelected ? 3 : 1)),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(
              iconpath,
              color: isSelected ? Colors.white : Colors.black87,
            )),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
