abstract final class FormatConverter {
  static IconSourceType converter(String? value) {
    if (value == null) {
      return IconSourceType.bucket;
    }
    final end = value.split('.').last.toLowerCase();
    final folder = value.endsWith('/');
    if (folder) {
      return IconSourceType.folder;
    } else {
      switch (end) {
        case 'jpg':
        case 'jpeg':
        case 'webm':
        case 'png':
        case 'svg':
        case 'tiff':
        case 'webp':
        case 'gif':
        case 'bmp':
        case 'tif':
          return IconSourceType.image;
        case 'html':
        case 'txt':
        case 'doc':
        case 'pdf':
        case 'xls':
          return IconSourceType.doc;
        case 'zip':
        case 'rar':
          return IconSourceType.archive;
        case 'exe':
        case 'apk':
        case 'aab':
        case 'app':
          return IconSourceType.program;
        case 'wav':
        case 'mp3':
        case 'wma':
        case 'aac':
        case 'flac':
          return IconSourceType.music;
        case 'mp4':
        case 'mob':
        case 'mkv':
        case 'm4v':
        case 'avi':
        case 'flv':
        case '3gp':
          return IconSourceType.video;
        default:
          return IconSourceType.other;
      }
    }
  }
}

enum IconSourceType {
  bucket,
  image,
  doc,
  folder,
  archive,
  program,
  music,
  video,
  other,
}
