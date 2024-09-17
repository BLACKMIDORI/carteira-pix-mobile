import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_bloc.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_event.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_state.dart';
import 'package:carteira_pix/components/clip_app_bar.dart';
import 'package:carteira_pix/data/bank_code_list.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/utils/black_midori_clipper.dart';
import 'package:carteira_pix/views/add_pix_key_dialog.dart';
import 'package:carteira_pix/views/export_pix_key_page.dart';
import 'package:carteira_pix/views/home_drawer.dart';
import 'package:carteira_pix/views/qr_code_pix_dialog.dart';
import 'package:carteira_pix/views/temporary_qr_code_pix_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'import_pix_key_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PixKeyBloc _pixKeyBloc = PixKeyBloc();

  @override
  void initState() {
    super.initState();
    _pixKeyBloc.add(PixKeyGetAllEvent());
  }

  void _onAddOrUpdateClick([String? id]) {
    showDialog(
      context: context,
      builder: (_) {
        return AddPixKeyDialog(id: id);
      },
    ).then((pixKey) {
      if (pixKey is PixKey) {
        if (pixKey.id.isEmpty) {
          _pixKeyBloc.add(PixKeyCreateEvent(pixKey: pixKey));
        } else {
          _pixKeyBloc.add(PixKeyUpdateEvent(pixKey: pixKey));
        }
      }
    });
  }

  void _onQrClick(PixKey pixKey) {
    showDialog(
      context: context,
      builder: (context) {
        return QrCodePixDialog(pixKey: pixKey);
      },
    );
  }

  void _onTemporaryQrClick() {
    showDialog(
      context: context,
      builder: (context) {
        return const TemporaryQrCodePixDialog();
      },
    );
  }

  void _onRemoveClick(PixKey pixKey) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: black,
            title: const Text("Remover chave"),
            content: Text("Deseja mesmo remover a chave '${pixKey.name}'?"),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Não',
                  style: TextStyle(color: purple),
                ),
              ),
              TextButton(
                onPressed: () {
                  _pixKeyBloc.add(PixKeyDeleteEvent(pixKey: pixKey));
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Sim',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }

  void _onCopyClick(PixKey pixKey) {
    Clipboard.setData(ClipboardData(text: pixKey.value))
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Chave copiada: ${pixKey.value}"),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Não foi possível copiar a chave.\nAtualize o app!"),
            ),
          ),
        );
  }

  Future<void> _onExportClick() async {
    unawaited(Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ExportPixKeyPage(
        pixKeys: _pixKeyBloc.state.pixKeyList,
      ),
    )));
  }

  Future<void> _onImportClick() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nenhum arquivo selecionado."),
          ),
        );

        return;
      }
      final platformFile = result.files.first;
      final file = File(platformFile.path!);
      final bytes = await file.readAsBytes();

      final Map<String, Object?> jsonObject;
      try {
        final jsonString = utf8.decode(bytes);
        jsonObject = jsonDecode(jsonString) as Map<String, Object?>;
      } on FormatException catch (_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Formato de arquivo inválido."),
          ),
        );

        return;
      }
      String errorMessage = "";
      if (jsonObject["appId"] != "com.blackmidori.carteirapix") {
        errorMessage += "Arquivo de outro aplicativo.\n";
      }
      if (jsonObject["type"] != "pix_key_list") {
        errorMessage += "Tipo de arquivo incorreto.\n";
      }
      if (jsonObject["version"] != 1) {
        errorMessage +=
            "Versão incompatível, apenas versão '1' é compatível.\n";
      }
      if (errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );

        return;
      }

      try {
        final List<Map<String, Object?>> jsonList =
            (jsonObject["data"]! as List<dynamic>).cast<Map<String, Object?>>();
        final pixKeysToAdd =
            jsonList.map((jsonObject) => PixKey.fromJson(jsonObject)).toList();

        final list = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ImportPixKeyPage(
            storedPixKeys: _pixKeyBloc.state.pixKeyList,
            pixKeys: pixKeysToAdd,
          ),
        ));
        if (list is List<PixKey>) {
          try {
            _pixKeyBloc.add(PixKeyMultipleCreateEvent(pixKeyList: list));
          } catch (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Falha ao adicionar chaves"),
                ),
              );
            }
          }
          // TODO: feature to update already existent keys
          // for (final value in list) {
          //   if (_pixKeyBloc.state.pixKeyList
          //       .any((element) => element.id == value.id)) {
          //     _pixKeyBloc.add(PixKeyUpdateEvent(pixKey: value));
          //   } else {
          //     _pixKeyBloc.add(PixKeyCreateEvent(pixKey: value));
          //   }
          // }
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao processar os dados do arquivo."),
          ),
        );
      }
    } on PlatformException catch (error) {
      if (error.code == "read_external_storage_denied") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Permissão de arquivos foi recusada!"),
          ),
        );
      } else {
        rethrow;
      }
    }

    // unawaited(Navigator.of(context).push(MaterialPageRoute(
    //   builder: (_) => ExportPixKeyPage(
    //     pixKeys: _pixKeyBloc.state.pixKeyList,
    //   ),
    // )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ClipAppBar(
        child: AppBar(
          title: const Text("Carteira Pix"),
          actions: [
            IconButton(
              onPressed: _onImportClick,
              icon: const Icon(Icons.file_upload),
              tooltip: "Importar de um arquivo",
            ),
            IconButton(
              onPressed: _onExportClick,
              icon: const Icon(Icons.file_download),
              tooltip: "Exportar para um arquivo",
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      drawer: const HomeDrawer(),
      body: BlocBuilder<PixKeyBloc, PixKeyState>(
        bloc: _pixKeyBloc,
        builder: (_, state) {
          if (state is PixKeyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PixKeyLoadedState) {
            if (state.pixKeyList.isEmpty) {
              return const Center(
                child: Text("Nenhuma chave adicionada ainda."),
              );
            }

            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(
                  top: 0,
                  bottom: mediaQuery.padding.bottom + 74,
                ),
              ),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final pixKey = state.pixKeyList[index];
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

                  return ListTile(
                    onTap: () => _onAddOrUpdateClick(pixKey.id),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _onQrClick(pixKey),
                          tooltip: "QR Code",
                          icon: const Icon(
                            Icons.qr_code,
                            color: brandColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onRemoveClick(pixKey),
                          tooltip: "Remover",
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onCopyClick(pixKey),
                          tooltip: "Copiar",
                          icon: const Icon(
                            Icons.copy,
                            color: brandColor,
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: state.pixKeyList.length,
              ),
            );
          }

          return const Center(
            child: Text("Estado incorreto! Por favor, reinicie o app."),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipPath(
            clipper: const BlackMidoriClipper(borderLength: 0.15),
            child: FloatingActionButton(
              shape: const RoundedRectangleBorder(),
              onPressed: _onTemporaryQrClick,
              tooltip: 'abrir qr code temporário',
              child: Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(-7, -7),
                    child: const Icon(Icons.qr_code),
                  ),
                  Transform.translate(
                    offset: const Offset(7, 7),
                    child: const Icon(Icons.access_time),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipPath(
            clipper: const BlackMidoriClipper(borderLength: 0.15),
            child: FloatingActionButton(
              shape: const RoundedRectangleBorder(),
              onPressed: _onAddOrUpdateClick,
              tooltip: 'Adicionar chave',
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
