// Source: https://stackoverflow.com/a/75142978
// Thanks!
import 'dart:convert';
import 'dart:typed_data';

int crc16_CCITT_FALSE(String data) {
  int initial = 0xFFFF; // initial value
  int polynomial = 0x1021; // 0001 0000 0010 0001  (0, 5, 12)

  Uint8List bytes = Uint8List.fromList(utf8.encode(data));

  for (var b in bytes) {
    for (int i = 0; i < 8; i++) {
      bool bit = ((b >> (7 - i) & 1) == 1);
      bool c15 = ((initial >> 15 & 1) == 1);
      initial <<= 1;
      if (c15 ^ bit) initial ^= polynomial;
    }
  }

  return initial &= 0xffff;
}
