import 'dart:async';

import 'package:carteira_pix/black_midori_theme.dart';
import 'package:carteira_pix/components/number_input_dialog.dart';
import 'package:carteira_pix/helpers/brazilian_pix_helper.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/models/pix_key_type.dart';
import 'package:carteira_pix/utils/black_midori_clipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// QrCodePixDialog
class QrCodePixDialog extends StatefulWidget {
  final PixKey pixKey;

  /// QrCodePixDialog constructor
  const QrCodePixDialog({
    Key? key,
    required this.pixKey,
  }) : super(key: key);

  @override
  State<QrCodePixDialog> createState() => _QrCodePixDialogState();
}

class _QrCodePixDialogState extends State<QrCodePixDialog> {
  String? _clipboardMessage;
  Timer? _clipboardMessageDebounce;
  final ValueNotifier<double?> _pixAmountInBRL = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();
  }

  String getPixQrCodeData() {
    String qrData;
    final pixKey = widget.pixKey;
    if (pixKey.type == PixKeyType.copy_and_paste) {
      qrData = pixKey.value;
    } else if (pixKey.type == PixKeyType.phone) {
      qrData = BrazilianPixHelper.generatePixCopyAndPaste(
        "+55${pixKey.value}",
        _pixAmountInBRL.value,
      );
    } else {
      qrData = BrazilianPixHelper.generatePixCopyAndPaste(
        pixKey.value,
        _pixAmountInBRL.value,
      );
    }
    if (kDebugMode) {
      print(qrData);
    }

    return qrData;
  }

  void onCopyClick() {
    final debounce = _clipboardMessageDebounce;

    if (debounce != null && debounce.isActive) {
      debounce.cancel();
    }
    _clipboardMessageDebounce = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _clipboardMessage = null;
        });
      }
    });

    Clipboard.setData(ClipboardData(text: getPixQrCodeData())).then(
      (value) {
        if (mounted) {
          setState(() {
            _clipboardMessage = "copiado!";
          });
        }

        return value;
      },
    ).catchError(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Não foi possível copiar a chave.\nAtualize o app!"),
        ),
      ),
    );
  }

  void onChangeAmountClick() {
    showDialog(
      context: context,
      builder: (context) {
        return NumberTwoDecimalsInputDialog(
          initialValue: _pixAmountInBRL.value,
          onChange: (value) {
            _pixAmountInBRL.value = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clipboardMessage = _clipboardMessage;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(clipboardMessage ?? ""),
                Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: onCopyClick,
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.maximumDensity,
                            vertical: VisualDensity.maximumDensity,
                          ),
                          icon: const Icon(
                            Icons.copy,
                            color: brandColor,
                          ),
                        ),
                        ClipPath(
                          clipper: const BlackMidoriClipper(borderLength: 0.2),
                          child: widget.pixKey.type == PixKeyType.copy_and_paste
                              ? const Text("Pix copia e cola")
                              : ElevatedButton(
                                  onPressed: onChangeAmountClick,
                                  child: ListenableBuilder(
                                    listenable: _pixAmountInBRL,
                                    builder: (_, __) {
                                      final pixAmountInBRL =
                                          _pixAmountInBRL.value;

                                      return Text(
                                        pixAmountInBRL == null
                                            ? "Definir valor"
                                            : "Mudar valor",
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.pixKey.type != PixKeyType.copy_and_paste)
                  ListenableBuilder(
                    listenable: _pixAmountInBRL,
                    builder: (_, __) {
                      final pixAmountInBRL = _pixAmountInBRL.value;

                      return Text(
                        pixAmountInBRL == null
                            ? "Valor não definido"
                            : "R\$ ${pixAmountInBRL.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      );
                    },
                  ),
                const SizedBox(
                  height: 14,
                ),
                ClipPath(
                  clipper: const BlackMidoriClipper(),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ListenableBuilder(
                          listenable: _pixAmountInBRL,
                          builder: (_, __) {
                            final qrData = getPixQrCodeData();

                            return QrImageView(
                              data: qrData,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(widget.pixKey.name),
                SizedBox(
                  height: 12,
                ),
                Text(widget.pixKey.value)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
