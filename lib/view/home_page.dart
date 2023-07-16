import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_bloc.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_state.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/services/pix_key_service.dart';
import 'package:carteira_pix/view/add_pix_key_dialog.dart';
import 'package:carteira_pix/view/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/pix_key/pix_key_event.dart';
import '../data/bank_code_list.dart';
import '../models/pix_key.dart';

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
    try {
      await PixKeyService().exportKeys(_pixKeyBloc.state.pixKeyList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carteira Pix"),
        actions: [
          IconButton(
            onPressed: _onExportClick,
            icon: const Icon(Icons.file_download),
          ),
          const SizedBox(width: 12),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddOrUpdateClick,
        tooltip: 'Adicionar chave',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
