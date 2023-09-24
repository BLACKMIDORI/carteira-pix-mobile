import 'package:flutter/cupertino.dart';

/// PixKeyListViewModel
class PixKeyListViewModel extends ChangeNotifier {
  final Set<String> _selectedPixKeyIds = <String>{};

  /// Selected pixKeyIds
  List<String> get selectedPixKeyIds =>
      _selectedPixKeyIds.toList(growable: false);

  /// Returns the number of pixKeyIds.
  int get length {
    return _selectedPixKeyIds.length;
  }

  /// Whether pixKeyIds has at least one pixKeyId
  bool get isNotEmpty {
    return _selectedPixKeyIds.isNotEmpty;
  }

  /// Add pixKeyId to selectedPixKeyIds.
  void selectPixKey(String pixKeyId) {
    selectPixKeyList([pixKeyId]);
  }

  /// Remove pixKeyId to selectedPixKeyIds.
  void unselectPixKey(String pixKeyId) {
    unselectPixKeyList([pixKeyId]);
  }

  /// Add all pixKeyId from pixKeyIdList to selectedPixKeyIds.
  void selectPixKeyList(List<String> pixKeyIdList) {
    for (final pixKeyId in pixKeyIdList) {
      if (_selectedPixKeyIds.add(pixKeyId)) {
        notifyListeners();
      }
    }
  }

  /// Remove all pixKeyId from pixKeyIdList to selectedPixKeyIds.
  void unselectPixKeyList(List<String> pixKeyIdList) {
    for (final pixKeyId in pixKeyIdList) {
      if (_selectedPixKeyIds.remove(pixKeyId)) {
        notifyListeners();
      }
    }
  }

  /// Remove all pixKeyId from selectedPixKeyIds.
  void unselectAll() {
    if (_selectedPixKeyIds.isNotEmpty) {
      _selectedPixKeyIds.clear();
      notifyListeners();
    }
  }

  /// Whether pixKeyId is in the list.
  bool contains(String pixKeyId) {
    return _selectedPixKeyIds.contains(pixKeyId);
  }
}
