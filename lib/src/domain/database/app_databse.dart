import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // Singelton instance
  static final AppDatabase _singleton = AppDatabase._();

  //singelton accessor
  static AppDatabase get instance => _singleton;

  //completer is used for transforming synchronous code into asynchronous code
  Completer<Database>? _dbOpenCompleter;

  // A private constructor: aloows us to create instances of AppDatabase
  // only from within the AppDatabase class iteself
  AppDatabase._();

  // database object accessor
  Future<Database> get database async {
    // if completer is null, AppDatabaseClass is
    // newly instantiated, so database is not yet opend
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // calling _openDatabase will also cpmlete the completer with databsae instance
      _openDatabse();
    }

    return _dbOpenCompleter!.future;
  }

  Future _openDatabse() async {
    final Directory appDocumentDir = await getApplicationDocumentsDirectory();

    final String dbPath = join(appDocumentDir.path, 'frontlineszambia.db');

    final Database database = await databaseFactoryIo.openDatabase(dbPath);

    _dbOpenCompleter!.complete(database);
  }
}
