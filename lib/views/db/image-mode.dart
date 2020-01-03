class Image {
  final int id;
  final int essay_id;
  final String directory;
  final String file_name;
  final String time;

  Image({this.id, this.essay_id, this.directory, this.file_name, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'essay_id': essay_id,
      'directory': directory,
      'file_name': file_name,
      'time': time,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  // 重写 toString 方法，以便使用 print 方法查看每个狗狗信息的时候能更清晰。
  @override
  String toString() {
    return 'Dog{id: $id, essay_id: $essay_id, directory: $directory, file_name: $file_name, time: $time}';
  }
}
