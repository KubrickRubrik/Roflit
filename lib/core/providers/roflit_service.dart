import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/s3roflit.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

part 'roflit_service.g.dart';

@riverpod
RoflitService roflitService(RoflitServiceRef ref, StorageEntity? storage) {
  return RoflitService(storage);
}

final class RoflitService {
  final StorageEntity? _storage;
  RoflitService(StorageEntity? storage) : _storage = storage;

  final _ycSerializer = _YCSerializer();
  final _vkSerializer = _VKSerializer();

  StorageInterface get roflit {
    return switch (_storage?.storageType) {
      StorageType.yxCloud => S3Roflit.yandex(
          accessKey: _storage!.accessKey,
          secretKey: _storage.secretKey,
          region: _storage.region,
        ),
      StorageType.vkCloud => S3Roflit.vkontakte(
          accessKey: _storage!.accessKey,
          secretKey: _storage.secretKey,
        ),
      _ => S3Roflit.yandex(
          accessKey: '',
          secretKey: '',
          region: '',
        ),
    };
  }

  StorageSerializerInterface get serizalizer {
    return switch (_storage?.storageType) {
      StorageType.yxCloud => _ycSerializer,
      StorageType.vkCloud => _vkSerializer,
      _ => _ycSerializer,
    };
  }
}

final class _YCSerializer implements StorageSerializerInterface {
  final _parser = Xml2Json();

  @override
  List<BucketEntity> buckets(Object? value) {
    try {
      final list = XmlDocument.parse(value as String).findAllElements('Bucket').toList();

      if (list.isEmpty) return [];

      return List.generate(list.length, (index) {
        final bucket = list[index];
        return BucketEntity(
          bucket: bucket.findElements('Name').single.innerText,
          countObjects: 5,
          creationDate: bucket.findElements('CreationDate').single.innerText,
        );
      });
    } catch (e) {
      return [];
    }
  }

  @override
  List<ObjectEntity> objects(Object? value) {
    _parser.parse(value as String);
    final json = jsonDecode(_parser.toParker());
    final document = json['ListBucketResult'];
    final keyCount = document['KeyCount'];
    final bucket = document['Name'];
    final isTruncated = document['IsTruncated'];
    final objects = document['Contents'] as List?;
    // try {
    // final document = XmlDocument.parse(value as String);
    log('--- toParker $keyCount');
    log('--- toParker $bucket');
    log('--- toParker $isTruncated');
    log('--- toParker $objects');
    final newObjects = List.generate(objects?.length ?? 0, (index) {
      final object = objects![index];
      return ObjectEntity(
        keyObject: object['Key'],
        size: double.parse(object['Size']),
        lastModified: object['LastModified'],
      );
    });

    return newObjects;
    // final objects = List.generate(list.length, (index) {
    //   final object = list[index];
    //   return ObjectEntity(
    //     keyObject: object.findElements('Key').single.innerText,
    //     size: int.parse(object.findElements('Size').single.innerText),
    //     lastModified: object.findElements('LastModified').single.innerText,
    //   );
    // });

    // return objects;
    // } catch (e) {
    //   print('>>>> ENPTY');
    //   return [];
    // }
  }
}

final class _VKSerializer implements StorageSerializerInterface {
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

  @override
  List<ObjectEntity> objects(Object? value) {
    return [];
  }
}

abstract interface class StorageSerializerInterface {
  List<BucketEntity> buckets(Object? value);
  List<ObjectEntity> objects(Object? value);
}
