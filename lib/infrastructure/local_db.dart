import 'dart:async';

import 'package:sqflite/sqflite.dart' as sqflite;

const fail = sqflite.ConflictAlgorithm.fail;
const replace = sqflite.ConflictAlgorithm.replace;

/// LocalDb
class LocalDb {
  /// Singleton Pix database
  static final LocalDb pixDb = LocalDb._internal();

  final Completer<sqflite.Database> _dbCompleter = Completer();

  /// Get LocalDB
  Future<sqflite.Database> get() async {
    if (!_dbCompleter.isCompleted) {
      _dbCompleter.complete(
        sqflite.openDatabase(
          'pix.db',
          version: 1,
          onCreate: (sqflite.Database db, int version) async {
            // When creating the db, create the table
            await db.execute('CREATE TABLE PixKey ('
                'id TEXT PRIMARY KEY,'
                'creationUnix INTEGER,' //TODO: change it before 2038
                'name TEXT,'
                'value TEXT,'
                'type INTEGER,'
                'bankCode INTEGER'
                ')');
          },
        ),
      );
    }

    return _dbCompleter.future;
  }

  /// LocalDb constructor
  LocalDb._internal();
}
