// import 'package:flutter/material.dart';

// import '../../bloc/blocs.dart';
// import '../../core/core.dart';

// class LanguageSettingsScreen extends StatefulWidget {
//   final String lang;

//   const LanguageSettingsScreen({Key? key , this.lang}) : super(key: key);
//   @override
//   _LanguageSettingsScreenState createState() => _LanguageSettingsScreenState();
// }

// class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
//   int _value;
//   @override
//   void initState() {
//     super.initState();

//     checkLanguage();
//   }

//   UiBloc uiBloc;
//   ApisBloc aBloc;
//   Widget build(BuildContext context) {
//     uiBloc = UiProvider.of(context);
//     aBloc = ApisProvider.of(context);

//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: Container(
//         color: cWhite,
//         padding: const EdgeInsets.symmetric(
//             vertical: size.height * 0.05, horizontal: size.width * 0.1),
//         child: Container(
//           child: Wrap(
//             spacing: 10,
//             children: List<Widget>.generate(
//               choices.length,
//               (int index) {
//                 return buildChoiceChips(index);
//               },
//             ).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       centerTitle: false,
//       title: Text(
//         Language.locale(uiBloc.lang, 'language'),
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           
//         ),
//       ),
//       automaticallyImplyLeading: false,
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.check),
//           onPressed: () {
//             aBloc.clearData();
//             Navigator.pushReplacementNamed(context, kRoot);
//           },
//         ),
//       ],
//       backgroundColor: cPrimaryColor,
//     );
//   }

//   ChoiceChip buildChoiceChips(int index) {
//     return ChoiceChip(
//       label: Container(
//         constraints: BoxConstraints(
//           minWidth: 50,
//         ),
//         child: Text(
//           choices[index],
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: _value != index ? cBlack : cWhite,
//             
//             fontWeight: _value != index ? FontWeight.normal : FontWeight.bold,
//           ),
//         ),
//       ),
//       selectedColor: cPrimaryColor,
//       selected: _value == index,
//       onSelected: (bool selected) {
//         uiBloc.lang = _langs[index];
//         uiBloc.prefs.setString('lang', uiBloc.lang);
//         setState(() {
//           _value = selected ? index : null;
//         });
//       },
//     );
//   }

//   checkLanguage() {
//     switch (widget.lang) {
//       case 'tg':
//         _value = 0;
//         break;
//       case 'or':
//         _value = 1;
//         break;
//       case 'am':
//         _value = 2;
//         break;
//       case 'en':
//         _value = 3;
//         break;
//       case 'af':
//         _value = 4;
//         break;
//       default:
//         _value = 0;
//         break;
//     }
//   }
// }

// const List<String> choices = [
//   'ትግርኛ',
//   'Afaan Oromoo',
//   'አማርኛ',
//   'English',
//   'Afar',
// ];
// const List<String> _langs = ['tg', 'or', 'am', 'en', 'af'];
