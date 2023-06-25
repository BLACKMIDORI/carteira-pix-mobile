enum PixKeyType {
  copy_and_paste,
  cpf_cnpj,
  phone,
  email,
  random,
}

extension PixKeyTypeExtension on PixKeyType {
  String get description {
    switch (this) {
      case PixKeyType.copy_and_paste:
        return "Copia e Cola";
      case PixKeyType.cpf_cnpj:
        return "CPF/CNPJ";
      case PixKeyType.phone:
        return "celular";
      case PixKeyType.email:
        return "e-mail";
      case PixKeyType.random:
        return "aleatória";
    }
  }
}
