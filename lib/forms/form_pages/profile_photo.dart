import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saathi/api/api_services.dart';
import 'package:saathi/database/models/user_model.dart';
import 'dart:io';

import 'package:saathi/forms/components/button.dart';

class ProfilePhoto extends StatefulWidget {
  final VoidCallback onContinue;
  const ProfilePhoto({super.key, required this.onContinue});

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  UserModel user = UserModel.getInstance;

  bool _isButtonEnable = false;
  bool _isLoading = false;
  bool _hasImageChanged = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final imageUrl = user.imageUrl;
    if (imageUrl != '') {
      setState(() {
        _isButtonEnable = true;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isButtonEnable = true;
        _hasImageChanged = true;
      });
    }
  }

  Future<void> saveImage() async {
    if (_image == null && !_hasImageChanged) {
      widget.onContinue();
      return;
    }

    setState(() {
      _isLoading = true; // Show loader
    });

      if (_hasImageChanged) {
        String imageUrl = await ApiService().uploadImageToServer(_image!);
        user.imageUrl = imageUrl;
      }

      widget.onContinue();
  }

  Future<void> _removeImage() async {
    if(user.imageUrl != '') {
      await ApiService().removeImageFromServer(user.imageUrl);
    }
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      foregroundImage: _image != null
                          ? FileImage(_image!)
                          : user.imageUrl != ''
                          ? NetworkImage(user.imageUrl)
                          : null,
                      child: _image == null && user.imageUrl == ''
                          ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[700],
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Add Photos to complete your Profile",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5),
                Text("Photo Privacy controls available in Settings",
                    style: TextStyle(color: Colors.grey)),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: ContinueButton(
                    text: 'Add from Gallery',
                    styleType: ButtonStyleType.enable,
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.image_search, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt, color: Colors.cyan),
                  label:
                  Text("Use Camera", style: TextStyle(color: Colors.cyan)),
                ),
              ],
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
            child: ContinueButton(
              text: _isLoading ? '' : 'Continue',
              styleType: _isButtonEnable
                  ? ButtonStyleType.enable
                  : ButtonStyleType.disable,
              onPressed: _isButtonEnable && !_isLoading ? saveImage : null,
              isLoading: _isLoading,
            ),
          ),

          // Spacer pushes the "Add Photos Later" button to the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                _removeImage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Photos Later",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(Icons.navigate_next, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}