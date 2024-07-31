
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider package
import 'DatabaseHelper.dart';
import 'ProfileForm.dart';
import 'User.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  late TextEditingController _levelController;
  late TextEditingController _passwordController;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _genderController = TextEditingController(text: widget.user.gender);
    _emailController = TextEditingController(text: widget.user.email);
    _studentIdController = TextEditingController(text: widget.user.studentId);
    _levelController = TextEditingController(text: widget.user.level.toString());
    _passwordController = TextEditingController(text: widget.user.password);

    // Check if profile photo URL is a valid file path
    if (widget.user.profilePhotoUrl.isNotEmpty &&
        widget.user.profilePhotoUrl.startsWith('file://')) {
      setState(() {
        _image = File(widget.user.profilePhotoUrl.substring(7)); // Remove 'file://' prefix
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _levelController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath = '${appDir.path}/user_profile_image.jpg';
    await imageFile.copy(imagePath);
    return 'file://$imagePath';
  }

  void _saveChanges() async {
    final updatedUser = User(
      name: _nameController.text,
      gender: _genderController.text,
      email: _emailController.text,
      studentId: _studentIdController.text,
      level: int.parse(_levelController.text),
      password: _passwordController.text,
      profilePhotoUrl: widget.user.profilePhotoUrl, // Keep the existing profile photo URL
    );

    DatabaseHelper.instance.updateUser(updatedUser);

    if (_image != null) {
      String newImageUrl = await _saveImageLocally(_image!); // Save image locally
      updatedUser.updateProfilePhotoUrl(newImageUrl);
      await DatabaseHelper.instance.updateUser(updatedUser);
    }

    final returnedUser = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: updatedUser),
      ),
    );

    if (returnedUser != null) {
      setState(() {
        widget.user.updateDetails(
          name: returnedUser.name,
          gender: returnedUser.gender,
          email: returnedUser.email,
          studentId: returnedUser.studentId,
          level: returnedUser.level,
          password: returnedUser.password,
          profilePhotoUrl: returnedUser.profilePhotoUrl,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Image Source'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text('Gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: const Text('Camera'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null && _image!.existsSync()
                      ? FileImage(_image!)
                      : widget.user.profilePhotoUrl.isNotEmpty &&
                      !widget.user.profilePhotoUrl.startsWith('file://')
                      ? NetworkImage(widget.user.profilePhotoUrl)
                      : AssetImage('assets/images/default_profile.png') as ImageProvider<Object>?,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _genderController,
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
              ),
            ),
            TextFormField(
              controller: _levelController,
              decoration: const InputDecoration(
                labelText: 'Level',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

