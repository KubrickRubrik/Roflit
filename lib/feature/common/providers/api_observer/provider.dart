import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class ApiObserverBloc extends _$ApiObserverBloc {
  @override
  ApiObserverState build() {
    return const ApiObserverState();
  }

  void createUploadObserver(int idBootloader) {
    state = state.copyWith(
      upload: ApiObjectObserver.addObserve(
        idBootloader: idBootloader,
      ),
    );
  }

  void removeUploadObserver() {
    state = state.copyWith(upload: null);
  }

  void onSendUploadProgress(ApiObjectValue value) {
    if (state.upload == null) return;
    state = state.copyWith(
      upload: state.upload?.copyWith(observe: value),
    );
  }
}
