import 'package:carteira_pix/models/entity.dart';
import 'package:carteira_pix/models/pix_key_type.dart';

/// PixKey
class PixKey extends Entity {
  final String id;
  final int creationUnix;
  final String name;
  final String value;
  final PixKeyType type;
  final int bankCode;

  DateTime get creationDateTime =>
      DateTime.fromMillisecondsSinceEpoch(creationUnix * 1000);

  /// PixKey contructor
  PixKey({
    required this.id,
    required this.creationUnix,
    required this.name,
    required this.value,
    required this.type,
    required this.bankCode,
  });

  /// Create PixKey from jsonObject
  factory PixKey.fromJson(Map<String, Object?> jsonObject) {
    return PixKey(
      id: jsonObject["id"]! as String,
      creationUnix: jsonObject["creationUnix"]! as int,
      name: jsonObject["name"]! as String,
      value: jsonObject["value"]! as String,
      type: PixKeyType.values[jsonObject["type"]! as int],
      bankCode: jsonObject["bankCode"]! as int,
    );
  }

  /// Serialize object into jsonObject
  Map<String, Object?> toJson() {
    return {
      "id": id,
      "creationUnix": creationUnix,
      "name": name,
      "value": value,
      "type": type.index,
      "bankCode": bankCode,
    };
  }
}
