class Essay {
  final int id;
  final String text;
  final String directory;
  final String time;

  Essay({this.id, this.text, this.directory, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'directory': directory,
      'time': time,
    };
  }

  @override
  String toString() {
    return 'Essagy{id: $id, text: $text, directory: $directory}, time: $time}';
  }
}
