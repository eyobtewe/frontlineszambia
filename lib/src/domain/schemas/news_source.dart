class NewsSource {
  late String name;
  late String url;

  NewsSource({required this.name, required this.url});

  NewsSource.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;

    return data;
  }
}
