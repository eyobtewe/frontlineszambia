// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firestore_search/firestore_search.dart';
// import 'package:flutter/material.dart';

// import '../../domain/schemas/schema.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({Key? key}) : super(key: key);

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreSearchScaffold(
//       showSearchIcon: true,
//       appBarTitle: 'Search',
//       appBarTitleColor: Colors.red,

//       firestoreCollectionName: 'posts',
//       searchBy: 'title.rendered',
//       dataListFromSnapshot: (QuerySnapshot ee) {
//         if (ee.docs.isEmpty) return [];

//         return ee.docs.map(
//           (QueryDocumentSnapshot<Object?> e) {
//             return Post.fromJson((e.data() as Map<String, dynamic>));
//           },
//         ).toList();
//       },
//       // builder: (_, snapshot) {
//       // return;
//       // },
//     );
//   }
// }
