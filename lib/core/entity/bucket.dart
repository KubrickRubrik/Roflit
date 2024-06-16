import 'package:freezed_annotation/freezed_annotation.dart';

part 'bucket.freezed.dart';

@freezed
class BucketEntity with _$BucketEntity {
  const factory BucketEntity({
    required String bucket,
    required String creationDate,
  }) = _BucketEntity;
}
