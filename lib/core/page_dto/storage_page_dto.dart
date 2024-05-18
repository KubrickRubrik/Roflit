final class StoragePageDto {
  final int? idStorage;
  final bool isCreateAccount;

  StoragePageDto({
    required this.isCreateAccount,
    this.idStorage,
  });

  StoragePageDto.empty()
      : isCreateAccount = false,
        idStorage = null;
}
