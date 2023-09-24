import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/components/clip_app_bar.dart';
import 'package:carteira_pix/data/bank_code_list.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/services/pix_key_service.dart';
import 'package:carteira_pix/view_models/pix_key_list_view_model.dart';
import 'package:flutter/material.dart';

class ExportPixKeyPage extends StatefulWidget {
  final List<PixKey> pixKeys;

  const ExportPixKeyPage({Key? key, required this.pixKeys}) : super(key: key);

  @override
  State<ExportPixKeyPage> createState() => _ExportPixKeyPageState();
}

class _ExportPixKeyPageState extends State<ExportPixKeyPage> {
  final PixKeyListViewModel viewModel = PixKeyListViewModel();

  Future<void> _onExportClick() async {
    try {
      final path = await PixKeyService().exportKeys(viewModel.selectedPixKeyIds
          .map(
            (pixKeyId) =>
                widget.pixKeys.firstWhere((pixKey) => pixKey.id == pixKeyId),
          )
          .toList());

      if (mounted) {
        if (path != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Chaves salvas com sucesso!"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Operação cancelada!"),
            ),
          );
        }
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Não foi fazer o download das chaves para um arquivo.\nAtualize o app!"),
        ),
      );
      // As I am catching all exception, rethrow it for debugging.
      rethrow;
    }
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
                    onPressed: viewModel.isNotEmpty ? _onExportClick : null,
                    icon: const Icon(Icons.file_download),
                  );
                }),
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
                trailing: Checkbox(
                  fillColor:
                      MaterialStatePropertyAll(isChecked ? brandColor : purple),
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
