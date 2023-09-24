import 'package:carteira_pix/black_midori_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _hugeAmount = 999999.99;

/// NumberInputDialog
class NumberTwoDecimalsInputDialog extends StatefulWidget {
  /// initialValue
  final double? initialValue;

  /// onChange
  final void Function(double? value) onChange;

  /// maxValue
  final double maxValue;

  /// NumberInputDialog contructor
  const NumberTwoDecimalsInputDialog({
    Key? key,
    this.initialValue,
    required this.onChange,
    this.maxValue = _hugeAmount,
  }) : super(key: key);

  @override
  State<NumberTwoDecimalsInputDialog> createState() =>
      _NumberTwoDecimalsInputDialogState();
}

class _NumberTwoDecimalsInputDialogState
    extends State<NumberTwoDecimalsInputDialog> {
  double _lastValidValue = 0;
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialValue = widget.initialValue;
    if (initialValue != null) {
      amountController.text = initialValue.toStringAsFixed(2);
    }
    amountController.addListener(_onChange);
  }

  void _onChange() {
    if (amountController.text.trim().isEmpty) {
      widget.onChange(null);

      return;
    }
    double amount;
    try {
      amount = double.parse(amountController.text.trim());
      if (amount != double.parse(amount.toStringAsFixed(2))) {
        print(amount.toStringAsFixed(2));
        print(amount.toString());
        amount = double.parse(amount.toStringAsFixed(2));
        amountController.text = amount.toStringAsFixed(2);
      }
    } on FormatException catch (e) {
      amountController.text = _lastValidValue.toString();

      return;
    }
    if (amount == 0) {
      _lastValidValue = amount;
      widget.onChange(null);

      return;
    }
    if (amount > _hugeAmount) {
      amount = _hugeAmount;
      amountController.text = amount.toString();
    }
    if (amount.toStringAsFixed(2) != amount.toString()) {
      amount = double.parse(amount.toStringAsFixed(2));
    }

    _lastValidValue = amount;
    widget.onChange(amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: black,
      content: TextField(
        autofocus: true,
        controller: amountController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
