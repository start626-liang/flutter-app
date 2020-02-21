class Travel {
  final int id;
  final String title;
  final String site;
  final int startTimeMilliseconds;
  final int endTimeMilliseconds;
  final String time;

  Travel(
      {this.id,
      this.title,
      this.site,
      this.startTimeMilliseconds,
      this.endTimeMilliseconds,
      this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'site': site,
      'startTimeMilliseconds': startTimeMilliseconds,
      'endTimeMilliseconds': endTimeMilliseconds,
      'time': time,
    };
  }

  @override
  String toString() {
    return '==Travel {id: $id, title: $title, site: $site, startTimeMilliseconds: $startTimeMilliseconds, endTimeMilliseconds: $endTimeMilliseconds}, time: $time}';
  }
}
