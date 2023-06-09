import 'dart:io';

class ImageRepository {
  static final ImageRepository _instance = ImageRepository._internal();

  factory ImageRepository() {
    return _instance;
  }

  ImageRepository._internal();

  File? _selectedImage;

  void setSelectedImage(File imageFile) {
    _selectedImage = imageFile;
  }

  File? getSelectedImage() {
    return _selectedImage;
  }
}
