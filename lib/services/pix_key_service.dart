import 'dart:convert';
import 'dart:io';

import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_list_file_data.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

/// PixKeyService
class PixKeyService {
  /// Export pix keys to a json file
  ///
  /// Returns: path of the saved file or null if operation was cancelled.
  Future<String?> exportKeys(List<PixKey> pixKeyList) async {
    final data = PixKeyListFileData(
        appId: "com.blackmidori.carteirapix", pixKeyList: pixKeyList);

    // Set path
    final temporaryDirectory = await getTemporaryDirectory();
    final tempFilePath =
        "${temporaryDirectory.path}/carteira_pix_chaves_${DateTime.now().millisecondsSinceEpoch}.json";

    // Create file
    final file = File(tempFilePath);
    await file.writeAsString(jsonEncode(data));

    // Open save file dialog
    final params = SaveFileDialogParams(sourceFilePath: tempFilePath);

    return await FlutterFileDialog.saveFile(params: params);
  }
}
