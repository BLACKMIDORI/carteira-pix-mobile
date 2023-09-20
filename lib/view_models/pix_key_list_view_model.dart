import 'package:flutter/cupertino.dart';

/// PixKeyListViewModel
class PixKeyListViewModel extends ChangeNotifier {
  final Set<String> _selectedPixKeyIds = <String>{};

  List<String> get selectedPixKeyIds =>
      _selectedPixKeyIds.toList(growable: false);

  void selectPixKey(String pixKeyId) {
    selectPixKeyList([pixKeyId]);
  }

  void unselectPixKey(String pixKeyId) {
    unselectPixKeyList([pixKeyId]);
  }

  void selectPixKeyList(List<String> pixKeyIdList) {
    pixKeyIdList.forEach((pixKeyId) {
      if (_selectedPixKeyIds.add(pixKeyId)) {
        notifyListeners();
      }
    });
  }

  void unselectPixKeyList(List<String> pixKeyIdList) {
    pixKeyIdList.forEach((pixKeyId) {
      if (_selectedPixKeyIds.remove(pixKeyId)) {
        notifyListeners();
      }
    });
  }

  void unselectAll() {
    if (_selectedPixKeyIds.length > 0) {
      _selectedPixKeyIds.clear();
      notifyListeners();
    }
  }

  bool contains(String pixKeyId) {
    return _selectedPixKeyIds.contains(pixKeyId);
  }

  bool any() {
    return _selectedPixKeyIds.any((element) => true);
  }

  int get length {
    return _selectedPixKeyIds.length;
  }
}
