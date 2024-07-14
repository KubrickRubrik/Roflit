part of 'provider.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState({
    @Default([]) List<UploadObjectEntity> uploads,
  }) = _UploadState;
}
