import 'package:carteira_pix/models/json_serializable.dart';

/// A model used for export/import json files
abstract class JsonFileData implements JsonObjectSerializable {
  final String appId;
  final String type;
  final int version;
  final JsonSerializable data;

  /// JsonFileData constructor
  JsonFileData({
    required this.appId,
    required this.type,
    required this.version,
    required this.data,
  });

  @override
  Map<String, Object?> toJson() =>
      {"appId": appId, "type": type, "version": version, "data": data.toJson()};
}
