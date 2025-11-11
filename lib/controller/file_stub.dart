// Stub file for web platform to avoid dart:io import
// This file is only used when compiling for web
// This should never actually be called since we check kIsWeb before using File

/// Stub File class for web compilation
class File {
  final String path;
  File(this.path);
  
  /// Stub method that matches dart:io File.writeAsBytes signature
  /// This will never be called on web since we check kIsWeb first
  Future<File> writeAsBytes(
    List<int> bytes, {
    dynamic mode,
    bool flush = false,
  }) async {
    throw UnsupportedError(
      'File operations are not supported on web. '
      'This should not be reached as kIsWeb is checked before File usage.',
    );
  }
}

