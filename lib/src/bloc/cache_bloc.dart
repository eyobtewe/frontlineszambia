import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repository/repository.dart';
import '../domain/schemas/schema.dart';

late SharedPreferences prefs;

Future<bool> lookInFavorites(Post post) async {
  // if (prefs != null) {
  //   return prefs.containsKey('${post.id}');
  // } else {
  prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('${post.id}');
  // }
}

class CacheBloc {
  final _repository = Repository();
  Map<String, List<Post>> savedPosts = {};

  // StreamController saved = StreamController<String>.broadcast();

  // Function get savedSnk => saved.sink.add;
  // Stream<String> get savedStr => saved.stream;

  // void dispose() {
  //   saved.close();
  // }

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> addToFavorites(Post post, String language) async {
    await prefs.setBool('favorites', true);
    await _savePost(post, language);
    bool b = await prefs.setString('${post.id}', '${post.id}');
    if (b) {
      // buildShowToast('Saved');
    } else {
      // buildShowToast('Already saved');
    }
  }

  Future<void> removeFavorites(Post post, String lang) async {
    await removePost(post, lang);
    await prefs.remove('${post.id}');
    // buildShowToast('Deleted');
  }

  Future<bool> removeAllFavorites() async {
    prefs.setBool('favorites', false);

    return await prefs.clear();
  }

  Future<bool> lookInFavorites(Post post) async {
    // if (prefs != null) {
    return prefs.containsKey('${post.id}');
    // } else {
    //   prefs = await SharedPreferences.getInstance();
    //   return prefs.containsKey('${post.id}');
    // }
  }

  Future<int?> _savePost(Post post, String language) async {
    return await _repository.savePost(post, language);
  }

  Future<int> removePost(Post post, String language) async {
    return await _repository.removePost(post, language);
  }

  Future<int> clearAll(String language) async {
    return await _repository.clearAll(language);
  }

  Future<List<Post>?> fetchSavedPosts(String language) async {
    savedPosts[language] = await _repository.fetchSavedPosts(language);
    return savedPosts[language];
  }

  Future<Post?> fetchPostDetail(int id, String language) async {
    return await _repository.fetchPostDetail(id, language);
  }
}
