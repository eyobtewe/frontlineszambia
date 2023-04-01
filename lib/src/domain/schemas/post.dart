import 'content.dart';
import 'media.dart';
import 'title.dart';

class Post {
  int? id;
  String? date;

  // int? featuredMediaID;
  String? link;
  String? source;

  Title? title;
  Content? content;

  Media? featuredMedia;

  Post({
    required this.date,
    this.source,
    required String title,
    required String content,
    required String featuredMedia,
    // this.featuredMediaID,
  })  : title = Title(rendered: title),
        featuredMedia = Media(sourceUrl: featuredMedia),
        content = Content(rendered: content);

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    source = json['source'];
    // featuredMediaID = json['featured_media'];

    link = json['link'];
    title = Title.fromJson(json['title']);
    featuredMedia = json['featured_media_data'] != null
        ? Media.fromJson(json['featured_media_data'])
        : null;
    content = Content.fromJson(json['content']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['source'] = date;
    data['id'] = id;

    data['title'] = title!.toJson();
    data['content'] = content!.toJson();
    if (featuredMedia != null) {
      data['featured_media_data'] = featuredMedia?.toJson();
    }
    // data['featured_media'] = featuredMediaID;
    return data;
  }

  @override
  String toString() {
    return 'Post: { id: $id, title: ${title!.rendered}, ';
  }
}
