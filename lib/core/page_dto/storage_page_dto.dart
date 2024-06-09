final class MenuStorageDto {
  final int? idStorage;
  final bool isCreateAccount;

  MenuStorageDto({
    required this.isCreateAccount,
    this.idStorage,
  });

  MenuStorageDto.empty()
      : isCreateAccount = false,
        idStorage = null;
}
