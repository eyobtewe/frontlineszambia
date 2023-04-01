// import '../../../external_src/flutter_wordpress.dart';

// class WpService {
//   WordPress wordpress;

//   Future<List<Post>> fetchPosts(
//     int categories,
//     int page,
//     int count, {
//     List<int> includePost,
//     List<int> excludePosts,
//     Tag tag,
//   }) async {
//     wordpress = WordPress(baseUrl: baseUrl);

//     List<Post> posts = <Post>[];
//     posts = await wordpress.fetchPosts(
//       postParams: ParamsPostList(
//         context: WordPressContext.view,
//         perPage: count,
//         pageNum: page,
//         includeCategories: categories != null ? [categories] : [],
//         includeTags: tag != null ? [tag.id] : [],
//         excludePostIDs: excludePosts,
//         includePostIDs: includePost,
//       ),
//     );

//     return posts;
//   }

//   Future<List<Post>> search(String term) async {
//     wordpress = WordPress(baseUrl: baseUrl);

//     List<Post> posts = await wordpress.fetchPosts(
//       postParams: ParamsPostList(
//         context: WordPressContext.view,
//         searchQuery: term,
//       ),
//     );

//     return posts;
//   }

//   Future<List<Tag>> fetchTags(Post post) async {
//     wordpress = WordPress(baseUrl: baseUrl);

//     List<Tag> tags = <Tag>[];

//     // List<int> chosenTopics = [
//     //   43, // "name": "News"
//     //   24, // "name": "Politics"
//     //   15, // "name": "Analysis"
//     //   29, // "name": "World"
//     //   23, // "name": "Opinion"
//     //   18, // "name": "Business"
//     // ];

//     tags = await wordpress.fetchTags(
//       params: ParamsTagList(
//         context: WordPressContext.view,
//         hideEmpty: true,
//         post: post?.id,
//         orderBy: CategoryTagOrderBy.count,
//         order: Order.desc,
//         excludeTagIDs: [
//           31, // amharic
//           20, // english
//         ],
//         // includeTagIDs: post == null ? chosenTopics : null,
//       ),
//     );

//     return tags;
//   }

//   Future<List<Category>> fetchCategories({int parent}) async {
//     wordpress = WordPress(baseUrl: baseUrl);

//     List<Category> categories = <Category>[];

//     categories = await wordpress.fetchCategories(
//       params: ParamsCategoryList(
//         context: WordPressContext.view,
//         hideEmpty: true,
//         orderBy: CategoryTagOrderBy.count,
//         order: Order.desc,
//         parent: parent,
//       ),
//     );

//     return categories;
//   }
// }

// const String baseUrl = 'https://frontlineszambia.com';
