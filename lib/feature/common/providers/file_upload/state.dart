part of 'provider.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState({
    @Default([]) List<BootloaderEntity> items,
  }) = _UploadState;
}
