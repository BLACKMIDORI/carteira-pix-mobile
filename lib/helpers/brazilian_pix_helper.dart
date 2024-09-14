import 'package:carteira_pix/helpers/crc16.dart';

/// BrazilianPixHelper
class BrazilianPixHelper {
  /// Generate Brazilian Pix Key based on BCB manual:
  ///
  /// https://www.bcb.gov.br/estabilidadefinanceira/pix?modalAberto=regulamentacao_pix
  static String generatePixCopyAndPaste(String pixKeyStr, [double? price]) {
    final payload = _generatePixCopyAndPastePayload(pixKeyStr, price);
    final verificationCode = crc16_CCITT_FALSE(payload);

    return payload + verificationCode.toRadixString(16).toUpperCase();
  }

  static String _generatePixCopyAndPastePayload(
      String pixKeyStr, double? price) {
    const defaultGUI = "BR.GOV.BCB.PIX";

    // Keys
    const payloadFormatIndicator = "00";
    const merchantAccountInformationPix = "26";
    const merchantAccountInformationPixGui = "00";
    const merchantAccountInformationPixPixKey = "01";
    const merchantCategoryCode = "52";
    const transactionCurrency = "53";
    const transactionAmount = "54";
    const countryCode = "58";
    const merchantName = "59";
    const merchantCity = "60";
    const crc16 = "63";

    // values
    const brl = "986";
    const nameAndFamilyName = "NOME COMPLETO";
    const city = "CIDADE";

    final payload = ""
        "$payloadFormatIndicator${_value("01")}"
        "$merchantAccountInformationPix${_value(""
            "$merchantAccountInformationPixGui${_value(defaultGUI)}"
            "$merchantAccountInformationPixPixKey${_value(pixKeyStr)}")}"
        "$merchantCategoryCode${_value("0000")}"
        "$transactionCurrency${_value(brl)}"
        "${price == null ? "" : "$transactionAmount${_value(price.toStringAsFixed(2))}"}"
        "$countryCode${_value("BR")}"
        "$merchantName${_value(nameAndFamilyName)}"
        "$merchantCity${_value(city)}"
        "$crc16"
        "04";

    return payload;
  }

  static String _value(String value) {
    final tam = value.length.toString().padLeft(2, "0");

    return "$tam$value";
  }
}
