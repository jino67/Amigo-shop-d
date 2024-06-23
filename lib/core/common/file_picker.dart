import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

final filePickerProvider = Provider<FilePickerRepo>((ref) => FilePickerRepo());

class FilePickerRepo {
  final picker = FilePicker.platform;

  FutureEither<File> pickImage([ImageSource? source]) async {
    return captureImage(source ?? ImageSource.gallery);
  }

  FutureEither<File> pickImageFromGallery() async {
    FilePickerResult? result = await picker.pickFiles(type: FileType.image);

    try {
      if (result == null) {
        return left(const Failure('No img selected'));
      }
      final file = File(result.files.single.path!);
      final compressedFile = await _compress(file);
      return compressedFile;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<File> captureImage(ImageSource source) async {
    final imgPicker = ImagePicker();

    final result = await imgPicker.pickImage(source: source);

    try {
      if (result == null) return left(const Failure('No img selected'));
      final file = File(result.path);
      final compressedFile = await _compress(file);
      return compressedFile;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<File> _compress(File image) async {
    try {
      final String path = image.path.toLowerCase();
      if (!path.contains('heic') && !path.contains('heif')) {
        return right(image);
      }

      final tmpDir = (await getTemporaryDirectory()).path;
      final target = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        target,
        format: CompressFormat.jpeg,
        quality: 90,
        autoCorrectionAngle: false,
        rotate: 90,
      );

      if (result == null) {
        return left(const Failure('Failed compressing image'));
      }

      return right(File(result.path));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<File>> pickFiles({List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await picker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: allowedExtensions,
      );

      if (result == null) {
        return left(const Failure('No file selected'));
      }

      final file = result.files.map((e) => File(e.path!)).toList();
      return right(file);
    } on PlatformException catch (e) {
      return left(Failure(e.message.toString()));
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

extension ImageSourceEx on ImageSource {
  IconData get icon {
    switch (this) {
      case ImageSource.camera:
        return Icons.camera_alt_outlined;
      case ImageSource.gallery:
        return Icons.image_outlined;
    }
  }
}
