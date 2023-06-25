import 'package:carteira_pix/blocs/pix_key/pix_key_event.dart';
import 'package:carteira_pix/blocs/pix_key/pix_key_state.dart';
import 'package:carteira_pix/models/pix_key.dart';
import 'package:carteira_pix/repositories/pix_key_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// PixKeyBloc bloc
class PixKeyBloc extends Bloc<PixKeyEvent, PixKeyState> {
  final _repository = PixKeyRepository();

  /// PixBloc constructor
  PixKeyBloc() : super(PixKeyLoadingState()) {
    on(_mapEventToState);
  }

  Future<void> _mapEventToState(
    PixKeyEvent event,
    Emitter<PixKeyState> emit,
  ) async {
    List<PixKey> pixKeyList = <PixKey>[];
    if (event is PixKeyGetAllEvent) {
      pixKeyList = (await _repository.getAll()).toList();
    } else if (event is PixKeyCreateEvent) {
      await _repository.save(event.pixKey);
      pixKeyList = (await _repository.getAll()).toList();
    } else if (event is PixKeyUpdateEvent) {
      await _repository.update(event.pixKey);
      pixKeyList = (await _repository.getAll()).toList();
    } else if (event is PixKeyDeleteEvent) {
      await _repository.delete(event.pixKey.id);
      pixKeyList = (await _repository.getAll()).toList();
    }
    emit(PixKeyLoadedState(pixKeyList: pixKeyList));
  }
}
