class Title {
  // String raw;
  late String rendered;

  Title({required this.rendered});

  Title.fromJson(Map<String, dynamic> json) {
    // raw = json['raw'];
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (this.raw != null) data['raw'] = this.raw;
    data['rendered'] = rendered;
    return data;
  }
}
