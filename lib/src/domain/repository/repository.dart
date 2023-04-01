import 'dart:async';

import '../database/article_dao.dart';
import '../schemas/schema.dart';
import '../services/firebase.dart';

class Repository {
  final ArticleDao _cache = ArticleDao();
  // final WpService wpService = WpService();
  final FirebaseService firebaseService = FirebaseService();

  Future<List<Post>> getPosts(
      {NewsSource? source, String? term, Map? id}) async {
    return await firebaseService.getPosts(source: source, term: term, id: id);
  }

  // Future<List<Post>> search(String query) async {
  // return await firebaseService.getPosts(source: source, term: term, id: id);
  // }

  Future<List<RadioStation>> getRadioStations() async {
    return await firebaseService.getRadioStations();
  }

  Future<List<NewsSource>> getNewsSources() async {
    return await firebaseService.getNewsSources();
  }

  Future<int?> savePost(Post post, String language) async {
    return await _cache.savePost(post, language);
  }

  Future<int> removePost(Post post, String language) async {
    return await _cache.removePost(post, language);
  }

  Future<int> clearAll(String language) async {
    return await _cache.clearAll(language);
  }

  Future<List<Post>> fetchSavedPosts(String language) async {
    return await _cache.fetchSavedPosts(language);
  }

  Future<Post?> fetchPostDetail(int id, String language) async {
    return await _cache.fetchPostDetail(id, language);
  }
}
