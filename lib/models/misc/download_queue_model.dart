class FileDownloaderQueueModel {
  final int id;
  final String url;
  final double? progress;
  final String downloadPath;

  FileDownloaderQueueModel({
    required this.id,
    required this.url,
    required this.progress,
    required this.downloadPath,
  });

  FileDownloaderQueueModel updateProgress(double? progress) {
    return FileDownloaderQueueModel(
      id: id,
      url: url,
      downloadPath: downloadPath,
      progress: progress,
    );
  }

  FileDownloaderQueueModel copyWith({
    int? id,
    String? url,
    double? progress,
    String? downloadPath,
  }) {
    return FileDownloaderQueueModel(
      id: id ?? this.id,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }
}
