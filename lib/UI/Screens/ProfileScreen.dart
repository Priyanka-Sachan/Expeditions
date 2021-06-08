import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expeditions/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static final id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User _user = User(
      uid: '',
      username: 'Anonymous',
      emailId: '',
      imageUrl:
          'https://www.pngfind.com/pngs/m/5-52097_avatar-png-pic-vector-avatar-icon-png-transparent.png');

  Future<void> getCurrentUser() async {
    final uid = _firebaseAuth.currentUser!.uid;
    _user = await User.getUser(_firestore, uid);
    setState(() {});
  }

  File _profileImage = File('');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    _profileImage = File(imageFile.path);
    if (_profileImage.path.isNotEmpty && _user.uid.isNotEmpty)
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users')
            .child(_user.uid + '.jpg');
        await storageRef.putFile(_profileImage);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(_user.uid)
            .update({'imageUrl': imageUrl});
        setState(() {
          _user.imageUrl = imageUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Your profile image could not be updated.')));
      }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Profile',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [Icon(Icons.exit_to_app_rounded), Text('Log Out')],
                ),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_user.imageUrl),
                  radius: 100,
                ),
                CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                        onPressed: _pickImage,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: Theme.of(context).backgroundColor,
                        )))
              ],
            ),
            Text(
              _user.username,
              style: TextStyle(fontSize: 48, fontFamily: 'Dancing Script'),
            )
          ],
        ),
      ),
    );
  }
}
