// filePicker
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class FileOrImagePickers {
//for single image upload
  Future<String?> pickSingleImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    return pickedImage!.path;
  }

  //Multiple Images Picker:
  Future<List<String>?> pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    return pickedImages.map((pickedImage) => pickedImage.path).toList();
  }

  Future<String?> pickSingleVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      return pickedVideo.path;
    }

    return null; // Return null if no video was picked.
  }

  // Future<List<String>?> pickMultipleVideos() async {
  //   final picker = ImagePicker();
  //   final pickedVideos = await picker.pickMultiVideo(source: ImageSource.gallery);
  //
  //   if (pickedVideos != null) {
  //     return pickedVideos.map((pickedVideo) => pickedVideo.path).toList();
  //   }
  //
  //   return null; // Return null if no videos were picked.
  // }
  //Single File Picker:
  Future<String?> pickSingleFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null) {
      return pickedFile.files.single.path;
    }

    return null; // Return null if no file was picked.
  }

  //for multiple file picker
  Future<List<String>?> pickMultipleFiles() async {
    FilePickerResult? pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (pickedFiles != null) {
      return pickedFiles.files.map((pickedFile) => pickedFile.path!).toList();
    }

    return null; // Return null if no files were picked.
  }
}
