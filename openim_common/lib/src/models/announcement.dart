class Announcement {
  String content;
  int id;
  bool isRead;
  int time;
  String title;
  String type;

  Announcement({
    required this.content,
    required this.id,
    required this.isRead,
    required this.time,
    required this.title,
    required this.type,
  });

  Announcement.fromJson(Map<String, dynamic> json)
      : content = json['content'] ?? '',
        id = json['id'] ?? 0,
        isRead = json['isRead'] ?? false,
        time = json['time'] ?? 0,
        title = json['title'] ?? '',
        type = json['type'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['id'] = id;
    data['isRead'] = isRead;
    data['time'] = time;
    data['title'] = title;
    data['type'] = type;
    return data;
  }
}
