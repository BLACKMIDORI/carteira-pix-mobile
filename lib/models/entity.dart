import 'package:carteira_pix/models/json_serializable.dart';

/// Entity
abstract class Entity implements JsonSerializable {
  abstract final String id;
}
