import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'pick_file_state.dart';

class PickFileCubit extends Cubit<PickFileState> {
  PickFileCubit() : super(PickFileInitial());

  FilePickerResult? image;

  void pickImage({required FilePickerResult? imageFile}) {
    if (imageFile == null || imageFile.files.isEmpty) {
      emit(PickFileFailure(message: 'No file was selected. Please try again.'));
      return;
    }

    final file = imageFile.files.first;

    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    if (file.extension == null ||
        !allowedExtensions.contains(file.extension!.toLowerCase())) {
      emit(PickFileFailure(message: 'Only image files are allowed.'));
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      emit(PickFileFailure(message: 'The file is larger than 5 MB.'));
      return;
    }

    image = imageFile;
    emit(PickFileSuccess(imageFile));
  }

  /// Returns the picked image bytes
  Uint8List? get imageBytes => image?.files.first.bytes;

  /// Returns the picked image file name
  String? get imageFileName => image?.files.first.name;

  /// Returns the picked image content type
  String? get imageContentType => _getContentType(image?.files.first.extension);

  String? _getContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
  }

  bool isImagePicked() {
    return image == null ? false : true;
  }

  void removeImage() {
    image = null;
    emit(PickFileInitial());
  }
}
