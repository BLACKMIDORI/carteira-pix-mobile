import 'dart:async';

import 'package:carteira_pix/infrastructure/local_db.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/repositories/repository.dart';
import 'package:carteira_pix/repositories/repository_operation_exceptions.dart';

/// PixKeyRepository
class PixKeyRepository extends Repository<PixKey> {
  final LocalDb _localDb = LocalDb.pixDb;
  static const String _tableName = "PixKey";

  @override
  Future<void> delete(String id) async {
    final db = await _localDb.get();
    await db.delete(_tableName, where: "id = $id");
  }

  @override
  Future<PixKey?> get(String id) async {
    final db = await _localDb.get();
    final result = await db.query(_tableName, where: "id = $id");
    final row = result.firstOrNull;
    if (row == null) {
      return null;
    }

    return PixKey.fromJson(row);
  }

  @override
  Future<Iterable<PixKey>> getAll() async {
    final db = await _localDb.get();
    final result = await db.query(_tableName, orderBy: 'creationUnix');

    print(result);
    return result.map((row) => PixKey.fromJson(row));
  }

  @override
  Future<void> save(PixKey entity) async {
    final db = await _localDb.get();
    final row = entity.toJson();
    row["id"] = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert(_tableName, row, conflictAlgorithm: fail);
  }

  @override
  Future<void> update(PixKey entity) async {
    final db = await _localDb.get();
    final foundEntity = await get(entity.id);
    if (foundEntity == null) {
      throw UpdatingNonExistentEntityException();
    }

    final result = await db.insert(_tableName, entity.toJson(),
        conflictAlgorithm: replace);
    if (result == 0) {
      throw RepositoryOperationException();
    }
  }
}
