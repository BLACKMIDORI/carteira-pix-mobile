import 'package:carteira_pix/models/entity.dart';

/// Repository
abstract class Repository<TModel extends Entity> {
  /// Get
  Future<TModel?> get(String id);

  /// GetAll
  Future<Iterable<TModel>> getAll();

  /// Save
  Future<void> save(TModel entity);

  /// Update
  Future<void> update(TModel entity);

  /// Delete
  Future<void> delete(String id);
}
