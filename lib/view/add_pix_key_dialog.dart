import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/components/midori_modal.dart';
import 'package:carteira_pix/data/bank_code_list.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/repositories/pix_key_repository.dart';
import 'package:carteira_pix/view_model/pix_key_view_model.dart';
import 'package:flutter/material.dart';

/// Regex for CPF or CNPJ (Brazilian Identification) pix key
final cpfCnpjPixKeyRegex = RegExp(
    r"(^\d{3}\.?\d{3}\.?\d{3}\-?\d{2}$)|(^\d{2}\.?\d{3}\.?\d{3}\/?\d{4}\-?\d{2}$)");

/// Regex for phone pix key
final phonePixKeyRegex = RegExp(
    r"^\(?(?:[1-9][1-9])\)? ?(?:[1-9]|9 ?[1-9])[0-9]{3}(?:\-| )?[0-9]{4}$");

/// Regex for email pix key
final emailPixKeyRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

/// Regex for random pix key
final randomPixKeyRegex = RegExp(
    r"^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$");

/// AddPixKeyDialog
class AddPixKeyDialog extends StatefulWidget {
  final String? id;

  /// AboutAppDialog constructor
  const AddPixKeyDialog({Key? key, this.id}) : super(key: key);

  @override
  State<AddPixKeyDialog> createState() => _AddPixKeyDialogState();
}

class _AddPixKeyDialogState extends State<AddPixKeyDialog> {
  final PixKeyViewModel _pixKeyViewModel = PixKeyViewModel();
  bool _isValid = false;

  final Iterable<MapEntry<int, String>> items = bankCodeMap.entries
      .map(
        (mapEntry) => MapEntry(
          mapEntry.key.contains("_") ? -1 : int.parse(mapEntry.key),
          mapEntry.value,
        ),
      )
      .where((mapEntry) => mapEntry.key != -1);

  @override
  void initState() {
    super.initState();
    final id = widget.id;
    _pixKeyViewModel.nameController.addListener(updateIsValid);
    _pixKeyViewModel.valueController.addListener(
      () {
        onPixKeyValueChange();
        updateIsValid();
      },
    );
    _pixKeyViewModel.typeNotifier.addListener(updateIsValid);
    _pixKeyViewModel.bankCodeNotifier.addListener(updateIsValid);

    if (id != null) {
      PixKeyRepository().get(id).then((value) {
        if (value != null && mounted) {
          setState(() {
            _pixKeyViewModel.previousData = value;
            _pixKeyViewModel.nameController.text = value.name;
            _pixKeyViewModel.valueController.text = value.value;
            _pixKeyViewModel.typeNotifier.value = value.type;
            _pixKeyViewModel.bankCodeNotifier.value = value.bankCode;
          });
        }
      });
    }
  }

  void _onBankChange(int? bankCode) {
    _pixKeyViewModel.bankCodeNotifier.value = bankCode;
  }

  void onPixKeyValueChange() {
    final value = _pixKeyViewModel.valueController.text;

    if (value.length > 2 &&
        value.substring(2, 3) == "9" &&
        phonePixKeyRegex.hasMatch(value)) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.phone;
    } else if (cpfCnpjPixKeyRegex.hasMatch(value)) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.cpf_cnpj;
    } else if (phonePixKeyRegex.hasMatch(value)) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.phone;
    } else if (emailPixKeyRegex.hasMatch(value)) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.email;
    } else if (randomPixKeyRegex.hasMatch(value)) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.random;
    } else if (value.isNotEmpty) {
      _pixKeyViewModel.typeNotifier.value = PixKeyType.copy_and_paste;
    } else {
      _pixKeyViewModel.typeNotifier.value = null;
    }
  }

  void updateIsValid() {
    if (_pixKeyViewModel.isValid() != _isValid) {
      setState(() {
        _isValid = !_isValid;
      });
    }
  }

  void _onConfirmClick() {
    Navigator.of(context).pop(_pixKeyViewModel.generatePixKey());
  }

  void _onCancelClick() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MidoriModal(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Nome"),
            TextField(
              controller: _pixKeyViewModel.nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Nome',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              textInputAction: TextInputAction.next, // Moves focus to next.
            ),
            const Divider(),
            const Text("Chave"),
            TextField(
              controller: _pixKeyViewModel.valueController,
              decoration: const InputDecoration(
                hintText: 'Chave',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              textInputAction: TextInputAction.next, // Moves focus to next.
            ),
            const Divider(),
            const Text("Tipo"),
            ValueListenableBuilder(
              valueListenable: _pixKeyViewModel.typeNotifier,
              builder: (context, value, _) {
                return Text(
                  value?.description ?? "PREENCHA A CHAVE",
                  style: const TextStyle(color: purple),
                );
              },
            ),
            const Divider(),
            const Text("Banco"),
            ValueListenableBuilder(
              valueListenable: _pixKeyViewModel.bankCodeNotifier,
              builder: (context, value, _) {
                return DropdownButton<int>(
                  dropdownColor: darkpurple,
                  value: value,
                  alignment: Alignment.center,
                  items: items.map((item) {
                    return DropdownMenuItem<int>(
                      value: item.key,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.loose(
                          Size.fromWidth(
                              MediaQuery.of(context).size.width - 200),
                        ),
                        child: Text(
                          "${item.key.toString().padLeft(3, "0")} - ${item.value}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _onBankChange,
                );
              },
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onCancelClick,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }

                          return purple;
                        },
                      ),
                    ),
                    child: const Text("Cancelar"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isValid ? _onConfirmClick : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }

                          return brandColor;
                        },
                      ),
                    ),
                    child: Text(_pixKeyViewModel.previousData != null
                        ? "Salvar alterações"
                        : "Adicionar"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pixKeyViewModel.dispose();
    super.dispose();
  }
}
