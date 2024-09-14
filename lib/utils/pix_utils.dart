import 'package:carteira_pix/models/pix_key_type.dart';

/// Regex for CPF or CNPJ (Brazilian Identification) pix key
final cpfCnpjPixKeyRegex = RegExp(
    r"(^\d{3}\.?\d{3}\.?\d{3}\-?\d{2}$)|(^\d{2}\.?\d{3}\.?\d{3}\/?\d{4}\-?\d{2}$)");

/// Regex for phone pix key
final phonePixKeyRegex = RegExp(
    // r"^\(?(?:[1-9][1-9])\)? ?(?:[1-9]|9 ?[1-9])[0-9]{3}(?:\-| )?[0-9]{4}$"
    r"^(?:[1-9][1-9])(?:9[1-9])[0-9]{3}[0-9]{4}$");

/// Regex for email pix key
final emailPixKeyRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

/// Regex for random pix key
final randomPixKeyRegex = RegExp(
    r"^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$");

/// Pix utility
abstract final class PixUtils {
  static PixKeyType? getPixType(String value) {
    if (value.length > 2 &&
        value.substring(2, 3) == "9" &&
        phonePixKeyRegex.hasMatch(value)) {
      return PixKeyType.phone;
    } else if (cpfCnpjPixKeyRegex.hasMatch(value)) {
      return PixKeyType.cpf_cnpj;
    } else if (phonePixKeyRegex.hasMatch(value)) {
      return PixKeyType.phone;
    } else if (emailPixKeyRegex.hasMatch(value)) {
      return PixKeyType.email;
    } else if (randomPixKeyRegex.hasMatch(value)) {
      return PixKeyType.random;
    } else if (value.isNotEmpty) {
      return PixKeyType.copy_and_paste;
    } else {
      return null;
    }
  }
}
