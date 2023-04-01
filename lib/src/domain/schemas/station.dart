class RadioStation {
  late String link;
  late String name;
  String? subtitle;
  String? description;
  String? imgUrl;

  @override
  String toString() {
    return '\n\n\t\t$name\t$subtitle\t$description';
  }

  RadioStation({
    required this.link,
    required this.name,
    this.subtitle,
    this.imgUrl,
    this.description,
  });

  RadioStation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
    subtitle = json['subtitle'];
    imgUrl = json['imgUrl'];
    description = json['description'];
  }

  Map<String, String?> toJson() {
    Map<String, String?> data = <String, String>{};
    data['name'] = name;
    data['link'] = link;
    data['subtitle'] = subtitle;
    data['imgUrl'] = imgUrl;
    data['description'] = description;
    return data;
  }
}
