import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/meta_object.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/services/format_converter.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/s3roflit.dart';
import 'package:xml2json/xml2json.dart';

part 'roflit_service.g.dart';

@riverpod
RoflitService roflitService(RoflitServiceRef ref, StorageEntity? storage) {
  return RoflitService(storage);
}

final class RoflitService {
  final StorageEntity? _storage;
  RoflitService(StorageEntity? storage) : _storage = storage;

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
      StorageType.yxCloud => _YCSerializer(host: roflit.host),
      StorageType.vkCloud => _VKSerializer(host: roflit.host),
      _ => _YCSerializer(host: roflit.host),
    };
  }
}

final class _YCSerializer implements StorageSerializerInterface {
  final String host;

  _YCSerializer({required this.host});

  final _parser = Xml2Json();

  @override
  List<BucketEntity> buckets(Object? value) {
    try {
      _parser.parse(value as String);
      final json = jsonDecode(_parser.toParker());
      final document = json['ListAllMyBucketsResult'];
      final buckets = document['Buckets']['Bucket'] as List?;

      final newBuckets = List.generate(buckets?.length ?? 0, (index) {
        final bucket = buckets![index];
        return BucketEntity(
          bucket: bucket['Name'],
          creationDate: bucket['CreationDate'],
        );
      });

      return newBuckets;
    } catch (e) {
      return [];
    }
  }

  @override
  List<ObjectEntity> objects(Object? value) {
    try {
      _parser.parse(value as String);
      final json = jsonDecode(_parser.toParker());
      final document = json['ListBucketResult'];

      final bucket = document['Name'];
      final objects = document['Contents'] as List?;

      final newObjects = List.generate(objects?.length ?? 0, (index) {
        final object = objects![index];
        return ObjectEntity(
          objectKey: object['Key'],
          bucket: bucket,
          type: FormatConverter.converter(object['Key']),
          nesting: FormatConverter.nesting(object['Key']),
          remotePath: '$host/$bucket/${object['Key']}',
          size: int.tryParse(object['Size']) ?? 0,
          lastModified: object['LastModified'],
        );
      });

      return newObjects;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ObjectEntity>> objectsFromFiles(List<File> files) async {
    try {
      final objects = <ObjectEntity>[];
      for (final file in files) {
        final objectKey = file.path.split('/').lastOrNull ?? '';
        final size = await file.length();
        objects.add(
          ObjectEntity(
            objectKey: objectKey,
            type: FormatConverter.converter(file.path),
            bucket: '',
            size: size,
            lastModified: '',
            localPath: file.path,
          ),
        );
      }

      return objects;
    } catch (e) {
      return [];
    }
  }

  @override
  MetaObjectEntity metaObjects(Object? value) {
    try {
      _parser.parse(value as String);
      final json = jsonDecode(_parser.toParker());
      final document = json['ListBucketResult'];

      return MetaObjectEntity(
        nextContinuationToken: document['NextContinuationToken'],
        keyCount: int.tryParse(document['KeyCount']) ?? 0,
        isTruncated: bool.tryParse(document['IsTruncated']) ?? false,
      );
    } catch (e) {
      return MetaObjectEntity.empty();
    }
  }
}

final class _VKSerializer implements StorageSerializerInterface {
  final String host;

  _VKSerializer({required this.host});

  @override
  List<BucketEntity> buckets(Object? value) {
    // try {
    //   // print('>>>> 1 $value');
    //   final listBucket = XmlDocument.parse(value as String).findAllElements('Bucket').toList();
    //   // print('>>>> 2 $listBucket');
    //   if (listBucket.isEmpty) return [];

    //   final buckets = List.generate(listBucket.length, (index) {
    //     final bucket = listBucket[index];
    //     return BucketEntity(
    //       bucket: bucket.findElements('Name').single.innerText,
    //       countObjects: 5,
    //       creationDate: bucket.findElements('CreationDate').single.innerText,
    //     );
    //   });
    //   return buckets;
    // } catch (e) {
    return [];
    // }
  }

  @override
  List<ObjectEntity> objects(Object? value) {
    return [];
  }

  @override
  Future<List<ObjectEntity>> objectsFromFiles(List<File>? value) async {
    return [];
  }

  @override
  MetaObjectEntity metaObjects(Object? value) {
    return MetaObjectEntity.empty();
  }
}

abstract interface class StorageSerializerInterface {
  List<BucketEntity> buckets(Object? value);
  List<ObjectEntity> objects(Object? value);
  Future<List<ObjectEntity>> objectsFromFiles(List<File> files);
  MetaObjectEntity metaObjects(Object? value);
}
