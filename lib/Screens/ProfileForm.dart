import 'dart:io';

import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'EditProfileScreen.dart';
import 'User.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User?> fetchCurrentUser() async {
    final user = await DatabaseHelper.instance.getUserByEmailAndPassword(widget.user.email, widget.user.password);
    if (user != null) {
      print('Fetched user: ${user.toMap()}');
    }
    return user;
  }

  Widget _buildProfilePhotoWidget(String profilePhotoUrl) {
    if (profilePhotoUrl.isNotEmpty && profilePhotoUrl.startsWith('file://')) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(File(profilePhotoUrl.substring(7))),
      );
    } else if (profilePhotoUrl.isNotEmpty && !profilePhotoUrl.startsWith('file://')) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(profilePhotoUrl),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(user: widget.user)),
              );
              if (updatedUser != null) {
                setState(() {
                  widget.user.updateDetails(
                    name: updatedUser.name,
                    gender: updatedUser.gender,
                    email: updatedUser.email,
                    studentId: updatedUser.studentId,
                    level: updatedUser.level,
                    password: updatedUser.password,
                    profilePhotoUrl: updatedUser.profilePhotoUrl,
                  );
                  print('Updated user: ${widget.user.profilePhotoUrl}');
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<User?>(
          future: fetchCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final currentUser = snapshot.data!;
              return ListView(
                children: [
                  SizedBox(height: 20),
                  _buildProfilePhotoWidget(currentUser.profilePhotoUrl), // Display profile photo
                  const SizedBox(height: 20.0),
                  Card(
                    child: ListTile(
                      title: Text('Name'),
                      subtitle: Text(currentUser.name),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(currentUser.email),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: ListTile(
                      title: Text('Student ID'),
                      subtitle: Text(currentUser.studentId),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: ListTile(
                      title: Text('Level'),
                      subtitle: Text(currentUser.level.toString()),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: ListTile(
                      title: Text('Gender'),
                      subtitle: Text(currentUser.gender),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No user found'));
            }
          },
        ),
      ),
    );
  }
}
