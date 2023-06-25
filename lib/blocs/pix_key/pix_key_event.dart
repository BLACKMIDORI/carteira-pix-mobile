import '../../models/pix_key.dart';

/// PixKeyEvent
class PixKeyEvent {}

/// PixKeyGetAllEvent
class PixKeyGetAllEvent extends PixKeyEvent {}

/// PixKeyCreateEvent
class PixKeyCreateEvent extends PixKeyEvent {
  /// PixKey to be created
  final PixKey pixKey;

  /// PixKeyCreateEvent constructor
  PixKeyCreateEvent({required this.pixKey});
}

/// PixKeyDeleteEvent
class PixKeyDeleteEvent extends PixKeyEvent {
  /// PixKey to be deleted
  final PixKey pixKey;

  /// PixKeyDeleteEvent constructor
  PixKeyDeleteEvent({required this.pixKey});
}

/// PixKeyUpdateEvent
class PixKeyUpdateEvent extends PixKeyEvent {
  /// PixKey to be updated
  final PixKey pixKey;

  /// PixKeyUpdateEvent constructor
  PixKeyUpdateEvent({required this.pixKey});
}
