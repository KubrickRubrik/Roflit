import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/enums.dart';
import 'package:xml/xml.dart';

part 'storage_serializer_interface.dart';

abstract final class StorageSerializer {
  static final _ycSerializer = YCSerializer();
  static final _vkSerializer = VKSerializer();

  static StorageSerializerInterface serializaer(StorageType type) {
    return switch (type) {
      StorageType.yxCloud => _ycSerializer,
      StorageType.vkCloud => _vkSerializer,
    };
  }
}

final class YCSerializer implements StorageSerializerInterface {
  @override
  List<BucketEntity> buckets(Object? value) {
    try {
      // print('>>>> 1 $value');
      final listBucket = XmlDocument.parse(value as String).findAllElements('Bucket').toList();
      // print('>>>> 2 $listBucket');
      if (listBucket.isEmpty) return [];

      final buckets = List.generate(listBucket.length, (index) {
        final bucket = listBucket[index];
        return BucketEntity(
          bucket: bucket.findElements('Name').single.innerText,
          countObjects: 5,
          creationDate: bucket.findElements('CreationDate').single.innerText,
        );
      });
      return buckets;
    } catch (e) {
      return [];
    }
  }
}

final class VKSerializer implements StorageSerializerInterface {
  @override
  List<BucketEntity> buckets(Object? value) {
    try {
      // print('>>>> 1 $value');
      final listBucket = XmlDocument.parse(value as String).findAllElements('Bucket').toList();
      // print('>>>> 2 $listBucket');
      if (listBucket.isEmpty) return [];

      final buckets = List.generate(listBucket.length, (index) {
        final bucket = listBucket[index];
        return BucketEntity(
          bucket: bucket.findElements('Name').single.innerText,
          countObjects: 5,
          creationDate: bucket.findElements('CreationDate').single.innerText,
        );
      });
      return buckets;
    } catch (e) {
      return [];
    }
  }
}
