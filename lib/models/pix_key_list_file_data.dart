import 'package:carteira_pix/models/json_file_data.dart';
import 'package:carteira_pix/models/json_serializable.dart';
import 'package:carteira_pix/models/pix_key.dart';

/// PixKeyListFileData
class PixKeyListFileData extends JsonFileData {
  final List<PixKey> pixKeyList;

  /// PixKeyListFileData
  PixKeyListFileData({required super.appId, required this.pixKeyList})
      : super(
            type: "pix_key_list",
            data: _ListSerializable(pixKeyList),
            version: 1);
}

class _ListSerializable<T extends JsonSerializable>
    implements JsonListSerializable {
  final List<T> list;
  _ListSerializable(this.list);

  @override
  List<Object> toJson() {
    return list.map((item) => item.toJson()).toList();
  }
}
