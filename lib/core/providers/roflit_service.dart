import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/meta_object.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/services/format_converter.dart';
import 'package:roflit_s3/roflit_s3.dart';
import 'package:xml2json/xml2json.dart';

part 'roflit_service.g.dart';

@riverpod
RoflitService roflitService(RoflitServiceRef ref, StorageEntity? storage) {
  return RoflitService(storage);
}

final class RoflitService {
  final StorageEntity? _cloudStorage;
  RoflitService(StorageEntity? storage) : _cloudStorage = storage;

  RoflitS3 get roflit {
    return switch (_cloudStorage?.storageType) {
      StorageType.yxCloud => RoflitS3.yandex(
          accessKeyId: _cloudStorage!.accessKey,
          secretAccessKey: _cloudStorage.secretKey,
          region: _cloudStorage.region,
          useLog: true,
        ),
      StorageType.vkCloud => RoflitS3.vk(
          accessKeyId: _cloudStorage!.accessKey,
          secretAccessKey: _cloudStorage.secretKey,
          region: _cloudStorage.region,
          useLog: true,
        ),
      _ => RoflitS3.yandex(
          accessKeyId: '',
          secretAccessKey: '',
          region: '',
        ),
    };
  }

  StorageSerializerInterface get serizalizer {
    return switch (_cloudStorage?.storageType) {
      StorageType.yxCloud => _YCSerializer(
          roflit: roflit,
        ),
      StorageType.vkCloud => _YCSerializer(
          roflit: roflit,
        ),
      _ => _YCSerializer(roflit: roflit),
    };
  }
}

final class _YCSerializer implements StorageSerializerInterface {
  final RoflitS3 roflit;

  _YCSerializer({required this.roflit});

  final _parser = Xml2Json();

  @override
  List<BucketEntity> buckets(Object? value) {
    try {
      _parser.parse(value as String);
      final json = jsonDecode(_parser.toParker());
      final document = json['ListAllMyBucketsResult'];
      final buckets = document['Buckets']['Bucket'];

      if (buckets is Map) {
        return [
          BucketEntity(
            bucket: buckets['Name'],
            creationDate: buckets['CreationDate'],
          )
        ];
      }

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
      final objects = document['Contents'];

      if (objects is Map) {
        final signedUrl = roflit.objects
            .get(bucketName: bucket, objectKey: objects['Key'], useSignedUrl: true)
            .url;

        return [
          ObjectEntity(
            objectKey: objects['Key'],
            bucket: bucket,
            type: FormatConverter.converter(objects['Key']),
            nesting: FormatConverter.nesting(objects['Key']),
            remotePath: '${roflit.host}/$bucket/${objects['Key']}',
            size: int.tryParse(objects['Size']) ?? 0,
            lastModified: objects['LastModified'],
            signedUrl: signedUrl.toString(),
          )
        ];
      }

      final newObjects = List.generate(objects?.length ?? 0, (index) {
        final object = objects![index];

        final signedUrl = roflit.objects
            .get(bucketName: bucket, objectKey: object['Key'], useSignedUrl: true)
            .url;

        return ObjectEntity(
          objectKey: object['Key'],
          bucket: bucket,
          type: FormatConverter.converter(object['Key']),
          nesting: FormatConverter.nesting(object['Key']),
          remotePath: '${roflit.host}/$bucket/${object['Key']}',
          size: int.tryParse(object['Size']) ?? 0,
          lastModified: object['LastModified'],
          signedUrl: signedUrl.toString(),
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
            objectKey: objectKey.toLowerCase(),
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
  final RoflitS3 roflit;

  _VKSerializer({required this.roflit});

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
