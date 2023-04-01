import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' show Client;

import '../schemas/schema.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final postsColl = firestore.collection('posts');
final sourcesColl = firestore.collection('sources');
final radioStationsColl = firestore.collection('radio_stations');
QueryDocumentSnapshot? lastPost;

class FirebaseService {
  Client client = Client();

  Future<List<Post>> getPosts(
      {NewsSource? source, String? term, Map? id}) async {
    try {
      if (id != null) {
        return await getSinglePost(id);
      } else if (source != null) {
        return await getSourcedPosts(source);
      } else {
        return (await getAllPosts()) ?? [];
      }
    } on FirebaseException catch (_) {
      // debugPrint('\n\n\n$e\n\n\n');
      return [];
    }
  }

  Future<List<Post>?> getAllPosts() async {
    Query query = lastPost != null
        ? postsColl
            .limit(20)
            .where('status', isEqualTo: 'PostStatus.published')
            .orderBy("timestamp", descending: true)
            .startAfterDocument(lastPost!)
        : postsColl
            .where('status', isEqualTo: 'PostStatus.published')
            .limit(20)
            .orderBy("timestamp", descending: true);

    return (await query.snapshots().first.then(
      (QuerySnapshot<Object?> ee) {
        // debugPrint('${ee.docs.length}');
        if (ee.docs.isEmpty) return [];

        lastPost = ee.docs.last;

        return ee.docs.map((QueryDocumentSnapshot<Object?> e) {
          return Post.fromJson((e.data() as Map<String, dynamic>));
        }).toList();
      },
    ));
  }

  Future<List<Post>> getSourcedPosts(NewsSource source) async {
    return await postsColl
        .where('source', isEqualTo: source.name)
        .where('status', isEqualTo: 'PostStatus.published')
        .orderBy("timestamp", descending: true)
        .limit(25)
        .get()
        .then(
      (QuerySnapshot<Map> value) {
        return value.docs.map(
          (e) {
            return Post.fromJson(e.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  Future<List<Post>> getSinglePost(Map<dynamic, dynamic> id) async {
    return await firestore
        .collection('posts')
        .where('source', isEqualTo: id.keys.first)
        .where('id', isEqualTo: int.parse(id.values.first))
        .get()
        .then(
      (QuerySnapshot<Map> value) {
        return value.docs.map(
          (QueryDocumentSnapshot<Map> e) {
            return Post.fromJson(e.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  Future<List<Post>> search(String query) async {
    return await firestore
        .collection('posts')
        .where('title.rendered', isGreaterThanOrEqualTo: query)
        .get()
        .then(
      (QuerySnapshot<Map> value) {
        return value.docs.map(
          (QueryDocumentSnapshot<Map> e) {
            return Post.fromJson(e.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  Future<List<NewsSource>> getNewsSources() async {
    return await sourcesColl.get().then(
      (value) {
        return value.docs.map(
          (QueryDocumentSnapshot e) {
            return NewsSource.fromJson(e.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  Future<List<RadioStation>> getRadioStations() async {
    return await radioStationsColl
        // .where('active', isNotEqualTo: false)
        .get()
        .then(
      (value) {
        return value.docs.map(
          (QueryDocumentSnapshot e) {
            return RadioStation.fromJson(e.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }
}

class FetchDataException implements Exception {
  final String _message;
  final int _code;

  FetchDataException(this._message, this._code);

  @override
  String toString() {
    return "\n\n\t\tException: $_message/$_code\n\n";
  }

  int code() {
    return _code;
  }
}
