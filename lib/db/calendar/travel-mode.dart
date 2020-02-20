class Travel {
  final int id;
  final String title;
  final String site;
  final int startTime;
  final int endTime;
  final String time;

  Travel(
      {this.id,
      this.title,
      this.site,
      this.startTime,
      this.endTime,
      this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'site': site,
      'startTime': startTime,
      'endTime': endTime,
      'time': time,
    };
  }

  @override
  String toString() {
    return 'Travel {id: $id, title: $title, site: $site, startTime: $startTime, endTime: $endTime}, time: $time}';
  }
}
