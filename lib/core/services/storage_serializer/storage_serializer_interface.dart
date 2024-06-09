part of 'storage_serializer.dart';

abstract interface class StorageSerializerInterface {
  List<BucketEntity> buckets(Object? value);
}
