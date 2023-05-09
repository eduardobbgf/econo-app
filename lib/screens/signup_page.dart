import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:econo_app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:econo_app/providers/user_provider.dart';

import 'home_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final ImageUpload _imageUpload = ImageUpload();

  String _name = '';
  String _errorMessage = '';
  String _email = '';
  String _password = '';
  late String _imageUrl = '';
  File? _pickedImage;
  String _fileName = '';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final String fileName =
          '${Path.basename(image.path)}_${DateTime.now().toString()}';
      setState(() {
        _pickedImage = image;
        _fileName = fileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: _imageUrl != ''
                                  ? NetworkImage(_imageUrl)
                                  : _pickedImage != null
                                      ? FileImage(_pickedImage!)
                                          as ImageProvider<Object>?
                                      : null,
                              child: _imageUrl == '' ? null : Container(),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _pickedImage != null || _imageUrl != ''
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _pickedImage = null;
                                            _imageUrl = '';
                                          });
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final String imageUrl = await _imageUpload.uploadFile(
                                  _pickedImage!, _fileName) ??
                              '';
                          setState(() {
                            _imageUrl = imageUrl;
                            _pickedImage = null;
                          });
                          User? user = await AuthService()
                              .registerWithEmailAndPassword(
                                  _email, _password, _name, _imageUrl);
                          print(user);
                          if (user == null) {
                            setState(() {
                              _errorMessage =
                                  "Não foi possível realizar o cadastro";
                            });
                          }
                          try {
                            if (user != null) {
                              setState(() {
                                _imageUrl = imageUrl;
                                _pickedImage = null;
                              });
                              user = FirebaseAuth.instance.currentUser;
                              userProvider.setUser(user);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage =
                                  "Não foi possível realizar o cadastro";
                            });
                          }
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                    _errorMessage != ''
                        ? Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageUpload {
  final picker = ImagePicker();

  Future<String?> uploadFile(File file, String fileName) async {
    try {
      // Upload the file to firebase storage

      final snapshot = await firebase_storage.FirebaseStorage.instance
          .ref(fileName)
          .putFile(file);

      // Get the download url of the uploaded file
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File?> pickImage() async {
    // Pick the image using the image picker plugin
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
