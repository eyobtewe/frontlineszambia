class Media {
  int? id;
  Caption? caption;
  int? post;
  String? sourceUrl;

  Media({
    this.id,
    this.caption,
    this.post,
    this.sourceUrl,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    caption =
        json['caption'] != null ? Caption.fromJson(json['caption']) : null;

    post = json['post'];
    sourceUrl = json['source_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    if (caption != null) {
      data['caption'] = caption?.toJson();
    }

    data['post'] = post;
    data['source_url'] = sourceUrl;

    return data;
  }
}

class Caption {
  String? raw;
  String? rendered;

  Caption({this.raw, this.rendered});

  Caption.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['rendered'] = rendered;
    return data;
  }
}
