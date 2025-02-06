import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';
import '../data/models/content_model.dart';
import 'content_encryption.dart';

class ContentUploadService {
  final SupabaseClient _client;
  final String _bucketName;

  ContentUploadService(this._client, {String bucketName = 'content'})
      : _bucketName = bucketName;

  /// Uploads the main media file and an optional thumbnail to Supabase Storage.
  /// Returns an updated [SecretContent] with storage URLs and metadata.
  Future<SecretContent> uploadMediaContent({
    required SecretContent content,
    required Uint8List fileBytes,
    Uint8List? thumbnailBytes,
  }) async {
    // Define a base storage path using the creatorId and contentId.
    final storagePath = '${content.creatorId}/${content.contentId}';
    final filePath = '$storagePath/original';

    // Encrypt fileBytes if required.
    final Uint8List uploadData = content.isEncrypted
        ? await ContentEncryptionService.encryptMedia(
            fileBytes, content.encryptionKey!)
        : fileBytes;

    // Upload main file.
    // Note: uploadBinary now returns a String, so error checking is done via exceptions.
    final fileUploadResponse =
        await _client.storage.from(_bucketName).uploadBinary(
              filePath,
              uploadData,
              fileOptions: FileOptions(
                contentType: content.mimeType,
              ),
            );

    // Get the public URL for the main file.
    final downloadUrl =
        _client.storage.from(_bucketName).getPublicUrl(filePath);

    // Upload thumbnail if provided.
    String? thumbnailPath;
    if (thumbnailBytes != null) {
      final thumbPath = '$storagePath/thumbnail';
      final thumbUploadResponse = await _client.storage
          .from(_bucketName)
          .uploadBinary(thumbPath, thumbnailBytes);
      // Get the public URL for the thumbnail.
      thumbnailPath = _client.storage.from(_bucketName).getPublicUrl(thumbPath);
    }

    // Update and return the content with the file URL, MIME type, file size, and thumbnail URL if exists.
    return content.copyWith(
      storagePath: downloadUrl,
      thumbnailPath: thumbnailPath,
      mimeType: content.mimeType,
      fileSize: fileBytes.length,
    );
  }

  /// Returns the public URL for a file stored at [path] in the bucket.
  Future<String> getDownloadUrl(String path) async {
    return _client.storage.from(_bucketName).getPublicUrl(path);
  }
}
