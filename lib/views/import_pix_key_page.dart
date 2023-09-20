import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/components/clip_app_bar.dart';
import 'package:carteira_pix/data/bank_code_list.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/view_models/pix_key_list_view_model.dart';
import 'package:flutter/material.dart';

import '../components/custom_check_box.dart';

class ImportPixKeyPage extends StatefulWidget {
  final List<PixKey> storedPixKeys;
  final List<PixKey> pixKeys;

  const ImportPixKeyPage({
    Key? key,
    required this.storedPixKeys,
    required this.pixKeys,
  }) : super(key: key);

  @override
  State<ImportPixKeyPage> createState() => _ImportPixKeyPageState();
}

class _ImportPixKeyPageState extends State<ImportPixKeyPage> {
  final PixKeyListViewModel viewModel = PixKeyListViewModel();

  // int get countNew {
  //   final storedIds = widget.storedPixKeys.map((pixKey) => pixKey.id);
  //
  //   return viewModel.selectedPixKeyIds
  //       .where((element) => !storedIds.contains(element))
  //       .length;
  // }

  Future<void> _onImportClick() async {
    final selectedKeys = viewModel.selectedPixKeyIds.map((pixKeyId) {
      return widget.pixKeys.firstWhere((pixKey) => pixKey.id == pixKeyId);
    });
    Navigator.of(context).pop(selectedKeys.toList());
  }

  void _onSelectAllClick() {
    if (viewModel.length < widget.pixKeys.length) {
      viewModel.selectPixKeyList(
        widget.pixKeys.map((pixKey) => pixKey.id).toList(),
      );
    } else {
      viewModel.unselectAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ClipAppBar(
        child: AppBar(
          title: const Text("Carteira Pix"),
          actions: [
            IconButton(
              onPressed: _onSelectAllClick,
              icon: const Icon(Icons.select_all),
            ),
            const SizedBox(
              width: 24,
            ),
            ListenableBuilder(
                listenable: viewModel,
                builder: (_, __) {
                  return IconButton(
                    onPressed: viewModel.any() ? _onImportClick : null,
                    icon: const Icon(Icons.file_upload),
                  );
                }),
            const SizedBox(
              width: 24,
            ),
            CircleAvatar(
              backgroundColor: black,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ListenableBuilder(
                            listenable: viewModel,
                            builder: (_, __) {
                              return Text(
                                viewModel.selectedPixKeyIds.length
                                    .toString()
                                    .padLeft(2, "0"),
                                style: const TextStyle(
                                    fontSize: 18, color: brandColor),
                              );
                            }),
                      )),
                  Center(
                    child: Transform.translate(
                      offset: const Offset(-12, 0),
                      child: const Icon(
                        Icons.add,
                        color: brandColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (_, __) {
          return ListView.builder(
            itemCount: widget.pixKeys.length,
            itemBuilder: (_, index) {
              final pixKey = widget.pixKeys[index];
              final IconData iconData;
              switch (pixKey.type) {
                case PixKeyType.copy_and_paste:
                  iconData = Icons.copy;
                case PixKeyType.cpf_cnpj:
                  iconData = Icons.perm_identity;
                case PixKeyType.phone:
                  iconData = Icons.phone_android;
                case PixKeyType.email:
                  iconData = Icons.alternate_email;
                case PixKeyType.random:
                  iconData = Icons.abc;
              }

              final isChecked = viewModel.contains(pixKey.id);

              void onTap() {
                if (isChecked) {
                  viewModel.unselectPixKey(pixKey.id);
                } else {
                  viewModel.selectPixKey(pixKey.id);
                }
              }

              final checkBoxColor = brandColor;
              final checkBoxIcon = Icons.add;

              return ListTile(
                onTap: onTap,
                leading: Icon(
                  iconData,
                  color: purple,
                ),
                title: Text(
                  "${pixKey.name} (${pixKey.value})",
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                subtitle: Text(
                    "${pixKey.bankCode} - ${bankCodeMap[pixKey.bankCode.toString()]}"),
                trailing: CustomCheckbox(
                  color: isChecked ? checkBoxColor : purple,
                  icon: Icon(
                    checkBoxIcon,
                    size: 20,
                    color: isChecked ? checkBoxColor : purple,
                  ),
                  value: isChecked,
                  onChanged: (_) => onTap(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
