import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'pick_file_state.dart';

class PickFileCubit extends Cubit<PickFileState> {
  PickFileCubit() : super(PickFileInitial());

  FilePickerResult? image;

  bool pickImage({required FilePickerResult? imageFile}) {
    if (imageFile == null || imageFile.files.isEmpty) {
      emit(PickFileFailure(message: 'No file was selected. Please try again.'));
      return false;
    }

    final file = imageFile.files.first;

    final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

    if (file.extension == null ||
        !allowedExtensions.contains(file.extension!.toLowerCase())) {
      emit(PickFileFailure(message: 'Only image files are allowed.'));
      return false;
    }

    if (file.size > 5 * 1024 * 1024) {
      emit(PickFileFailure(message: 'The file is larger than 5 MB.'));
      return false;
    }

    image = imageFile;
    emit(PickFileSuccess(imageFile));
    return true;
  }

  Uint8List? get imageBytes => image?.files.first.bytes;

  String? get imageFileName => image?.files.first.name;

  String? get imageContentType => _getContentType(image?.files.first.extension);

  String? _getContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
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
