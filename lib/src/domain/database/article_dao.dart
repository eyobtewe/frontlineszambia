import 'package:sembast/sembast.dart';

import '../schemas/schema.dart';
import 'app_databse.dart';

class ArticleDao {
  // static const String POSTS_STORE_NAME_TG = 'posts_tg';
  // static const String POSTS_STORE_NAME_EN = 'posts_en';
  // static const String POSTS_STORE_NAME_AM = 'posts_am';
  // final _postsStoreEn = intMapStoreFactory.store(POSTS_STORE_NAME_EN);
  // final _postsStoreTg = intMapStoreFactory.store(POSTS_STORE_NAME_TG);
  // final _postsStoreAm = intMapStoreFactory.store(POSTS_STORE_NAME_AM);

  final StoreRef _articlesStore = intMapStoreFactory.store('posts_en');

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<int?> savePost(Post article, String lang) async {
    // StoreRef _articlesStore = (lang == 'en' || lang == 'all')
    //     ? _postsStoreEn
    //     : (lang == 'tg' ? _postsStoreTg : _postsStoreAm);

    int data = await _update(article, _articlesStore);
    if (data == 0) {
      return await _articlesStore.add(
        await _db,
        article.toJson(),
      );
    }
    return null;
  }

  Future<int> _update(Post article, StoreRef _articlesStore) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final art = Post.fromJson(record.value);
        return (art.id == article.id);
      }),
    );

    return await _articlesStore.update(
      await _db,
      article.toJson(),
      finder: finder,
    );
  }

  Future<int> removePost(Post article, String lang) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final art = Post.fromJson(record.value);
        return (art.id == article.id);
      }),
    );
    // StoreRef _articlesStore = (lang == 'en' || lang == 'all')
    //     ? _postsStoreEn
    //     : (lang == 'tg' ? _postsStoreTg : _postsStoreAm);

    return await _articlesStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<int> clearAll(String lang) async {
    // StoreRef _articlesStore = (lang == 'en' || lang == 'all')
    //     ? _postsStoreEn
    //     : (lang == 'tg' ? _postsStoreTg : _postsStoreAm);

    return await _articlesStore.delete(await _db);
  }

  Future<List<Post>> fetchSavedPosts(String lang) async {
    // StoreRef _articlesStore = (lang == 'en' || lang == 'all')
    //     ? _postsStoreEn
    //     : (lang == 'tg' ? _postsStoreTg : _postsStoreAm);

    final List<RecordSnapshot> recordSnapshots = await _articlesStore.find(
      await _db,
    );

    return recordSnapshots.map((e) {
      final article = Post.fromJson(e.value);
      return article;
    }).toList();
  }

  Future<Post?> fetchPostDetail(int id, String lang) async {
    final _finder = Finder(
      filter: Filter.custom((matches) {
        final post = Post.fromJson(matches.value);
        return (post.id == id);
      }),
    );

    // StoreRef _articlesStore = (lang == 'en' || lang == 'all')
    //     ? _postsStoreEn
    //     : (lang == 'tg' ? _postsStoreTg : _postsStoreAm);

    final List<RecordSnapshot> recordSnapshots = await _articlesStore.find(
      await _db,
      finder: _finder,
    );

    return recordSnapshots.isNotEmpty
        ? Post.fromJson(recordSnapshots.first.value)
        : null;
  }
}
