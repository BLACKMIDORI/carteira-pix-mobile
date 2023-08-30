import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/view_models/view_model_exceptions.dart';
import 'package:flutter/cupertino.dart';

/// PixKeyViewModel
class AddPixKeyViewModel {
  /// id
  PixKey? previousData;

  /// nameController
  final TextEditingController nameController = TextEditingController();

  /// valueController
  final TextEditingController valueController = TextEditingController();

  /// typeNotifier
  final ValueNotifier<PixKeyType?> typeNotifier = ValueNotifier(null);

  /// bankCodeNotifier
  final ValueNotifier<int?> bankCodeNotifier = ValueNotifier(null);

  /// Verify if data on view model is valid
  bool isValid() {
    return nameController.value.text.isNotEmpty &&
        valueController.value.text.isNotEmpty &&
        typeNotifier.value != null &&
        bankCodeNotifier.value != null;
  }

  /// generatePixKey
  PixKey generatePixKey() {
    if (!isValid()) {
      throw InvalidViewModelStateException();
    }

    final nowUnix = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    return PixKey(
      id: previousData?.id ?? '',
      creationUnix: previousData?.creationUnix ?? nowUnix,
      name: nameController.text,
      value: valueController.text,
      type: typeNotifier.value!,
      bankCode: bankCodeNotifier.value!,
    );
  }

  /// Dispose all controllers
  void dispose() {
    nameController.dispose();
    typeNotifier.dispose();
    bankCodeNotifier.dispose();
  }
}
