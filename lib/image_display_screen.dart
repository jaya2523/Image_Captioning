import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'image_display_screen.dart';
import 'image_repository.dart';

import 'package:http/http.dart' as http;

Future<String> predictImage(File imageFile) async {
  var url = Uri.parse('https://aaef-34-86-139-148.ngrok.io/image'); // Replace with the API endpoint

  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var json = jsonDecode(responseBody);
    return json['fname'];
  } else {
    return "null";
  }
}


class ImageDisplayScreen extends StatefulWidget {
  const ImageDisplayScreen({Key? key}) : super(key: key);

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreen();
}

class _ImageDisplayScreen extends State<ImageDisplayScreen> {
  final ImageRepository _imageRepository = ImageRepository();
  String selectedImagePath = '';
  String predictedClass = '';

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        _imageRepository.setSelectedImage(imageFile);
        selectedImagePath = imageFile.path;
        predictedClass = '';
      }
    });
  }


  Future<void> _predictImage() async {
    if (selectedImagePath != '') {
      var imageFile = File(selectedImagePath);
      var result = await predictImage(imageFile);
      setState(() {
        predictedClass = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedImagePath == ''
                  ? Image.asset(
                'assets/image_placeholder.png',
                height: 300,
                width: 340,
                fit: BoxFit.fill,
              )
                  : Image.file(
                File(selectedImagePath),
                height: 300,
                width: 340,
                fit: BoxFit.fill,
              ),
              Text(
                'Select Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, fontFamily: 'BreeSerif',),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.transparent,
                  elevation: 10,
                ),
                onPressed: _selectImage,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade800,
                        Colors.blue.shade700,
                        Colors.blue.shade600,
                        Colors.blue.shade500,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'BreeSerif',),
                    ),
                  ),
                ),
              ),


              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.transparent,
                  elevation: 10,
                ),
                onPressed: _predictImage,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade800,
                        Colors.blue.shade700,
                        Colors.blue.shade600,
                        Colors.blue.shade500,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Predict',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'BreeSerif',),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
              Text(
                'Prediction Result: $predictedClass',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: 'BreeSerif',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.all(4),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     primary: Colors.transparent,
              //     elevation: 10,
              //   ),
              //   onPressed: _navigateToNextPage,
              //   child: Container(
              //     width: 200,
              //     height: 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(30),
              //       gradient: LinearGradient(
              //         colors: [
              //           Colors.blue.shade800,
              //           Colors.blue.shade700,
              //           Colors.blue.shade600,
              //           Colors.blue.shade500,
              //         ],
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //       ),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Next',
              //         style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'BreeSerif',),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _selectImagefrom() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Select Image From',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final imageFile = File(pickedFile.path);
                            _imageRepository.setSelectedImage(imageFile);
                            selectedImagePath = imageFile.path;
                            predictedClass = '';
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Selected!"),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/gallery.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text('Gallery'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            final imageFile = File(pickedFile.path);
                            _imageRepository.setSelectedImage(imageFile);
                            selectedImagePath = imageFile.path;
                            predictedClass = '';
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Captured!"),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/camera.png',
                                  height: 60,
                                  width: 60,
                                ),
                                Text('Camera'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDisplayScreen(),
      ),
    );
  }


  saveImage(String path) async {
    final bytes = await File(path).readAsBytes();
    await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
  }


  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  //
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }
}
