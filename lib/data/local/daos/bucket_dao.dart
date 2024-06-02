part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountTable, StorageTable])
class BucketDao extends DatabaseAccessor<ApiDatabase> with _$BucketDaoMixin {
  BucketDao(super.attachedDatabase);

  Future<String> getActiveBucket() async {
    return '';
  }
}
