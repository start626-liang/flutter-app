class ImageDate {
  final int id;
  final int directory;
  final String fileName;
  final String time;

  ImageDate(this.directory, this.fileName, this.time, {this.id });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'directory': directory,
      'fileName': fileName,
      'time': time,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  // 重写 toString 方法，以便使用 print 方法查看每个狗狗信息的时候能更清晰。
  @override
  String toString() {
    return 'ImageDate {id: $id, directory: $directory, fileName: $fileName, time: $time}';
  }
}
