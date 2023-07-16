/// Interface for make a class json serializable
abstract class JsonSerializable {
  /// Serialize object data for jsonDecode
  Object toJson();
}

/// Interface for make a class json serializable
abstract class JsonObjectSerializable implements JsonSerializable {
  /// Serialize object data for jsonDecode
  Map<String, Object?> toJson();
}

/// Interface for make a class json serializable
abstract class JsonListSerializable implements JsonSerializable {
  /// Serialize object data for jsonDecode
  List<Object?> toJson();
}
