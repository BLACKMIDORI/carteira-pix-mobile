import 'package:carteira_pix/models/pix_key.dart';

/// PixKeyState
class PixKeyState {
  /// PixKey list
  final List<PixKey> pixKeyList;

  /// PixKeyState constructor
  PixKeyState({required this.pixKeyList});
}

/// PixKeyLoadingState
class PixKeyLoadingState extends PixKeyState {
  /// PixKeyLoadingState constructor
  PixKeyLoadingState() : super(pixKeyList: []);
}

/// PixKeyLoadedState
class PixKeyLoadedState extends PixKeyState {
  /// PixKeyStateLoading constructor
  PixKeyLoadedState({required super.pixKeyList});
}
