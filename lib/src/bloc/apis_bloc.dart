import 'dart:async';

import '../domain/repository/repository.dart';
import '../domain/schemas/schema.dart';
import '../domain/services/firebase.dart';

class ApisBloc {
  final _repository = Repository();

  List<Post>? posts;
  List<NewsSource>? newsSources;
  List<RadioStation>? radioStations;

  Map<dynamic, List<Post>> sourceBasedPosts = {};
  List<Post>? searchResults;

  // Future<List<Post>> search(String query) async {
  // return await _repository.getPosts(source: source, term: term, id: id);
  // }

  Future<List<Post>?> getPosts(
      {NewsSource? source, String? term, Map? id}) async {
    List<Post> data =
        await _repository.getPosts(source: source, term: term, id: id);

    data.removeWhere((Post p) {
      return p.content!.rendered == '';
    });

    if (source != null) sourceBasedPosts[source.name] = data;
    if (term != null) searchResults = data;

    if (source == null && term == null) {
      if (posts != null) {
        posts!.addAll(data);
      } else {
        posts = data;
      }

      posts?.toSet().toList();

      return posts;
    }

    return data;
  }

  Future<List<NewsSource>?> getNewsSources() async {
    newsSources = await _repository.getNewsSources();
    return newsSources;
  }

  Future<List<RadioStation>?> getRadioStations() async {
    radioStations = await _repository.getRadioStations();
    return radioStations;
  }

  void clearData() {
    if (lastPost != null) lastPost = null;
    if (posts != null) posts = null;
    newsSources?.clear();
    radioStations?.clear();
  }

  Future<void> init() async {
    getPosts();
    getNewsSources();
  }
}
