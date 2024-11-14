import 'package:flutter/foundation.dart';  // kIsWeb kontrolü için
import 'package:image_picker/image_picker.dart';

// Mobil platformlarda dart:io import edilecek
// Web platformu için ise import edilmeyecek
// Bu sayede dart:io hatası çözülmüş olacak
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' if (dart.library.io) 'dart:io' as io;

class MediaService {
  final ImagePicker picker = ImagePicker();

  MediaService();

  Future<Object?> pickImage() async {
    final XFile? _file = await picker.pickImage(source: ImageSource.gallery);

    if (_file != null) {
      if (kIsWeb) {
        // Web platformu için dosyayı Uint8List olarak döndür
        return await _file.readAsBytes();
      } else {
        // Mobil platformlar için dosya yolunu File ile döndür
        return io.File(_file.path);
      }
    } else {
      return null;
    }
  }
}
