import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'image_display_screen.dart';
import 'image_repository.dart';
import 'main.dart';

Future<List<String>> predictImage(File imageFile) async {
  var url = Uri.parse(
      'https://d54e-34-73-55-14.ngrok.io/image'); // Replace with the API endpoint
  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var json = jsonDecode(responseBody);
    List<dynamic> predictions = json['predictions'];
    List<String> predictedClasses =
        predictions.map((prediction) => prediction.toString()).toList();
    return predictedClasses;
  } else {
    return [];
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageRepository _imageRepository = ImageRepository();
  String selectedImagePath = '';
  String predictedClass = '';
  List<String> predictedClasses = [];

  void initState() {
    super.initState();

    /// whenever your initialization is completed, remove the splash screen:
    Future.delayed(Duration(seconds: 1)).then((value) => {
      FlutterNativeSplash.remove()
    });
  }

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance); // Add this line

  runApp(MyApp());
}
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
        predictedClasses = result;
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: 'BreeSerif',
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'BreeSerif',
                      ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'BreeSerif',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
              Text(
                predictedClasses.isNotEmpty
                    ? predictedClasses[0]
                        .toString()
                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                    : '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'BreeSerif',
                ),
              ),
              Text(
                predictedClasses.length > 1
                    ? predictedClasses[1]
                        .toString()
                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                    : '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'BreeSerif',
                ),
              ),
              Text(
                predictedClasses.length > 1
                    ? predictedClasses[2]
                        .toString()
                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                    : '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Select Image From',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker()
                              .getImage(source: ImageSource.gallery);
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
                          final pickedFile = await ImagePicker()
                              .getImage(source: ImageSource.camera);
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

  // void _navigateToNextPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ImageDisplayScreen(),
  //     ),
  //   );
  // }

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
